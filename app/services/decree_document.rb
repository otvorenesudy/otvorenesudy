# frozen_string_literal: true

require 'ipaddr'
require 'net/http'
require 'resolv'

# A decree's PDF, fetched from where the court system publishes it (the decree's pdf_uri) for a visitor's browser. It
# follows redirects only on the same host over http(s), and connects only to public addresses, so a document address
# or a redirect can't make the server fetch its own services (Elasticsearch, Redis) for a visitor.
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
    # was first taken, so the place of a process that died comes back.
    def hold_place
      count = Rails.cache.increment(FETCHES_KEY, 1, expires_in: 1.minute)
      raise Busy, "#{FETCHES} documents are being fetched" if count && count > FETCHES

      yield
    ensure
      Rails.cache.decrement(FETCHES_KEY, 1) if count
    end

    # The response, with its body when it succeeded.
    def get(uri, deadline)
      remaining = deadline - Time.current
      raise Unavailable, "No document within #{DEADLINE} s for [#{uri}]" unless remaining.positive?

      options = { use_ssl: uri.scheme == 'https', open_timeout: [OPEN_TIMEOUT, remaining].min,
                  read_timeout: [READ_TIMEOUT, remaining].min, ipaddr: public_address(uri.host) }

      Net::HTTP.start(uri.host, uri.port, **options) do |http|
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

    # The host's address to connect to: refused when any of its addresses is the server itself or its network.
    def public_address(host)
      addresses = Resolv.getaddresses(host).map { |address| IPAddr.new(address) }

      raise Unavailable, "[#{host}] has no address" if addresses.empty?
      raise Unavailable, "[#{host}] is a private address" if addresses.any? { |address| private_address?(address) }

      addresses.first.to_s
    end

    def private_address?(address)
      address.loopback? || address.private? || address.link_local? || address.to_i.zero?
    end
  end
end
