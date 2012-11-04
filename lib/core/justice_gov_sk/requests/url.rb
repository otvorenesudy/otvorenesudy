module JusticeGovSk
  module Requests
    module URL
      def self.base
        'http://www.justice.gov.sk'
      end
      
      def self.uri_to_path(downloader, uri)
        uri  = URI.parse(uri)
        path = uri.path
        
        path.gsub!(/Stranky\/Pojednavania/i,      'hearings')
        path.gsub!(/Stranky\/Sudcovia/i,          'judges')
        path.gsub!(/Stranky\/Sudne-rozhodnutia/i, 'decrees')
        path.gsub!(/Stranky\/Sudy/i,              'courts')
        
        path = "#{downloader.cache_root}#{path}"
        path = "#{path}.#{downloader.cache_file_extension}" unless downloader.cache_file_extension.nil?
    
        uri.query.nil? ? path : "#{path}?#{uri.query}"
      end
      
      def self.uri_to_path_lambda
        @uri_to_path_lambda ||= lambda { |downloader, uri| JusticeGovSk::Requests::URL.uri_to_path(downloader, uri) }
      end
    end
  end
end
