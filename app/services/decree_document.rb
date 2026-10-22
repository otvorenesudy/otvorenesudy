# frozen_string_literal: true

require 'ipaddr'
require 'net/http'
require 'resolv'

# A decree's PDF, fetched from where the court system publishes it (the decree's pdf_uri) for a visitor's browser. It
# follows redirects only on the same host over http(s), and connects only to public addresses, so a document address
# or a redirect can't make the server fetch its own services (Elasticsearch, Redis) or its networks' for a visitor.
#
# Any visitor can start a fetch, so fetches are bounded: at most FETCHES at once across the app's processes, the others
# refused at once rather than left waiting, so slow sources can't hold every process; DEADLINE seconds and MAX_SIZE
# bytes each.
class DecreeDocument
  class Unavailable < StandardError; end
  class Busy < StandardError; end

  FETCHES = 4
  FETCHES_KEY = 'decree_document/fetches'
  OPEN_TIMEOUT = 5
  READ_TIMEOUT = 10
  DEADLINE = 20
  MAX_SIZE = 20.megabytes
  REDIRECTS = 3
  SCHEMES = %w[http https].freeze

  # IANA's special-purpose IPv4 ranges: this network, private, shared (carrier-grade NAT), loopback, link-local,
  # protocol assignments, documentation, 6to4 relays, benchmarking, multicast, reserved and broadcast. An IPv6 address
  # must be global unicast (2000::/3), which leaves out loopback, IPv4-mapped, NAT64, discard, unique local, link-local
  # and multicast addresses; within it, protocol assignments (Teredo among them), 6to4 and documentation.
  NON_PUBLIC = %w[
    0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.0.0.0/24 192.0.2.0/24
    192.88.99.0/24 192.168.0.0/16 198.18.0.0/15 198.51.100.0/24 203.0.113.0/24 224.0.0.0/4 240.0.0.0/4
    2001::/23 2001:db8::/32 2002::/16 3fff::/20
  ].map { |range| IPAddr.new(range) }.freeze
  GLOBAL_UNICAST = IPAddr.new('2000::/3')

  NETWORK_ERRORS = [
    Timeout::Error, SocketError, SystemCallError, IOError, OpenSSL::SSL::SSLError, Net::HTTPBadResponse,
    Net::ProtocolError, URI::InvalidURIError
  ].freeze

  def self.fetch(url)
    uri = web_address(URI(url))
    deadline = Time.current + DEADLINE

    hold_place do
      (REDIRECTS + 1).times do
        response, body = get(uri, deadline)

        return body if response.is_a?(Net::HTTPSuccess)
        raise Unavailable, "[#{response.code}] for [#{uri}]" unless response.is_a?(Net::HTTPRedirection)

        uri = redirect(uri, response['location'])
      end

      raise Unavailable, "Too many redirects for [#{url}]"
    end
  rescue *NETWORK_ERRORS => e
    raise Unavailable, "#{e.class}: #{e.message} for [#{url}]"
  end

  class << self
    private

    # Takes one of the FETCHES places for the block, or refuses with all taken. The count expires a minute after it
    # was first taken, so the place of a process that died comes back. Giving a place back after the count expired
    # starts a new count, which must expire too: memcached keeps a count it starts without an expiry forever.
    def hold_place
      count = Rails.cache.increment(FETCHES_KEY, 1, expires_in: 1.minute)
      raise Busy, "#{FETCHES} documents are being fetched" if count && count > FETCHES

      yield
    ensure
      Rails.cache.decrement(FETCHES_KEY, 1, expires_in: 1.minute) if count
    end

    # The response, with its body when it succeeded.
    def get(uri, deadline)
      remaining = deadline - Time.current
      raise Unavailable, "No document within #{DEADLINE} s for [#{uri}]" unless remaining.positive?

      options = { use_ssl: uri.scheme == 'https', open_timeout: [OPEN_TIMEOUT, remaining].min,
                  read_timeout: [READ_TIMEOUT, remaining].min, ipaddr: public_address(uri.hostname) }

      Net::HTTP.start(uri.hostname, uri.port, **options) do |http|
        http.request(Net::HTTP::Get.new(uri)) do |response|
          break [response, (read(response, deadline) if response.is_a?(Net::HTTPSuccess))]
        end
      end
    end

    def read(response, deadline)
      raise Unavailable, "Larger than #{MAX_SIZE} bytes" if response.content_length.to_i > MAX_SIZE

      body = ''.b

      response.read_body do |chunk|
        body << chunk

        raise Unavailable, "Larger than #{MAX_SIZE} bytes" if body.bytesize > MAX_SIZE
        raise Unavailable, "No document within #{DEADLINE} s" if Time.current > deadline
      end

      body
    end

    def redirect(uri, location)
      target = web_address(uri.merge(location.to_s))

      raise Unavailable, "Redirect from [#{uri.host}] to another host [#{target.host}]" unless target.host == uri.host

      target
    end

    def web_address(uri)
      raise Unavailable, "[#{uri}] isn't a web address" unless SCHEMES.include?(uri.scheme) && uri.host.present?

      uri
    end

    # The host's address to connect to: refused when any of its addresses isn't public.
    def public_address(host)
      addresses = Resolv.getaddresses(host).map { |address| IPAddr.new(address) }

      raise Unavailable, "[#{host}] has no address" if addresses.empty?

      refused = addresses.reject { |address| public?(address) }
      raise Unavailable, "[#{host}] has an address that isn't public [#{refused.join(', ')}]" if refused.any?

      addresses.first.to_s
    end

    def public?(address)
      (address.ipv4? || GLOBAL_UNICAST.include?(address)) && NON_PUBLIC.none? { |range| range.include?(address) }
    end
  end
end
