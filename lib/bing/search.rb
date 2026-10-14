# frozen_string_literal: true

module Bing
  # Up to 100 results for the query, without those whose URL matches `exclude`; nil when the response isn't JSON.
  class Search
    ENDPOINT = 'https://api.datamarket.azure.com/Bing/Search/v1/Web'

    attr_accessor :query, :exclude

    def perform
      url = "#{ENDPOINT}?#{URI.encode_www_form('Query' => "'#{query}'", '$format' => 'json', '$top' => 100)}"

      parse(fetch(url))
    rescue JSON::ParserError
      Bing::Cache.delete(url)

      nil
    end

    private

    def fetch(url)
      Bing::Cache.get(url) || Bing::Cache.store(url, request(URI(url)))
    end

    def request(uri)
      request = Net::HTTP::Get.new(uri)
      request.basic_auth('', Bing.api_key.to_s)

      Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 10, read_timeout: 30) do |http|
        http.request(request).body
      end
    end

    def parse(data)
      results = JSON.parse(data, symbolize_names: true).dig(:d, :results).to_a

      results.filter_map do |result|
        { title: result[:Title], description: result[:Description], url: result[:Url] } if valid?(result)
      end
    end

    def valid?(result)
      exclude ? !exclude.match?(result[:Url]) : true
    end
  end
end
