module Bing
  class Search
    attr_accessor :query,
                  :exclude

    def perform
      url = "https://api.datamarket.azure.com/Bing/Search/v1/Web?Query='#{@query}'&$format=json&$top=100"

      data = connect(url)

      begin
        parse(data)
      rescue JSON::ParserError
        Bing::Cache.delete(url)

        return
      end
    end

    private

    def connect(url)
      uri  = URI.encode(url)
      data = Bing::Cache.get(uri)

      unless data
        curl = Curl::Easy.new(uri)

        curl.http_auth_types = :basic
        curl.username        = ''
        curl.password        = Bing::API_KEY

        curl.perform

        data = curl.body_str

        Bing::Cache.store(uri, data)
      end

      data
    end

    def parse(data)
      json    = JSON.parse(data, symbolize_names: true)
      results = Array.new

      json[:d][:results].each do |result|
        next unless valid?(result)

        results << { title: result[:Title], description: result[:Description], url: result[:Url] }
      end

      results
    end

    def valid?(result)
      return @validator.call(result) if @validator && @validator.respond_to?(:call)

      return !@exclude.match(result[:Url]) if @exclude

      true
    end
  end
end
