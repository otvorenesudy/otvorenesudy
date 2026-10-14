# frozen_string_literal: true

require 'net/http'

# A decree's PDF, fetched from where the court system publishes it (the decree's pdf_uri).
class DecreeDocument
  class Unavailable < StandardError; end

  TIMEOUT = 15
  REDIRECTS = 3

  NETWORK_ERRORS = [
    Timeout::Error, SocketError, SystemCallError, IOError, OpenSSL::SSL::SSLError, Net::HTTPBadResponse,
    Net::ProtocolError, URI::InvalidURIError
  ].freeze

  def self.fetch(url, redirects: REDIRECTS)
    response = get(URI(url))

    case response
    when Net::HTTPSuccess then response.body
    when Net::HTTPRedirection
      raise Unavailable, "Too many redirects for [#{url}]" if redirects.zero?

      fetch(URI.join(url, response['location']).to_s, redirects: redirects - 1)
    else
      raise Unavailable, "[#{response.code}] for [#{url}]"
    end
  rescue *NETWORK_ERRORS => e
    raise Unavailable, "#{e.class}: #{e.message} for [#{url}]"
  end

  class << self
    private

    def get(uri)
      options = { use_ssl: uri.scheme == 'https', open_timeout: TIMEOUT, read_timeout: TIMEOUT }

      Net::HTTP.start(uri.host, uri.port, **options) { |http| http.request(Net::HTTP::Get.new(uri)) }
    end
  end
end
