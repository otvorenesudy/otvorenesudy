# frozen_string_literal: true

require 'ipaddr'
require 'net/http'
require 'resolv'

# A decree's PDF, fetched from where the court system publishes it (the decree's pdf_uri) for a visitor's browser. It
# follows redirects only on the same host over http(s), and connects only to public addresses, so a document address
# or a redirect can't make the server fetch its own services (Elasticsearch, Redis) for a visitor.
class DecreeDocument
  class Unavailable < StandardError; end

  TIMEOUT = 15
  REDIRECTS = 3
  SCHEMES = %w[http https].freeze

  NETWORK_ERRORS = [
    Timeout::Error, SocketError, SystemCallError, IOError, OpenSSL::SSL::SSLError, Net::HTTPBadResponse,
    Net::ProtocolError, URI::InvalidURIError
  ].freeze

  def self.fetch(url)
    uri = web_address(URI(url))

    (REDIRECTS + 1).times do
      response = get(uri)

      return response.body if response.is_a?(Net::HTTPSuccess)
      raise Unavailable, "[#{response.code}] for [#{uri}]" unless response.is_a?(Net::HTTPRedirection)

      uri = redirect(uri, response['location'])
    end

    raise Unavailable, "Too many redirects for [#{url}]"
  rescue *NETWORK_ERRORS => e
    raise Unavailable, "#{e.class}: #{e.message} for [#{url}]"
  end

  class << self
    private

    def get(uri)
      options = { use_ssl: uri.scheme == 'https', open_timeout: TIMEOUT, read_timeout: TIMEOUT,
                  ipaddr: public_address(uri.host) }

      Net::HTTP.start(uri.host, uri.port, **options) { |http| http.request(Net::HTTP::Get.new(uri)) }
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
