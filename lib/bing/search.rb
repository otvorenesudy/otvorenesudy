module Bing
  class Search
    attr_accessor :query

    def perform
      url = "https://api.datamarket.azure.com/Bing/Search/v1/Web?Query='#{@query}'&$format=json"

      data = connect(url)

      begin
        parse(data)
      rescue JSON::ParserError
        Bing::Cache.del(url)

        return nil
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
        results << { title: result[:Title], description: result[:Description], url: result[:Url] }
      end

      results
    end

  end
end
