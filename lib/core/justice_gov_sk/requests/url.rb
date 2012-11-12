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
                
        path.gsub!(/\/SudDetail/i,              '')
        path.gsub!(/Sudne-rozhodnutie-detail/i, 'decree')
        path.gsub!(/PojednavanieDetail/i,       'civil/civil-hearing')
        path.gsub!(/PojednavanieTrestDetail/i,  'criminal/criminal-hearing')
        path.gsub!(/PojednavanieSpecDetail/i,   'special/special-hearing')
        
        #path.gsub!(/IdTp|IdVp|IdSpecSudKonanie/i, 'id')
        
        path.downcase!
        
        path = "#{downloader.cache_root}#{path}"
        path = "#{path}.#{downloader.cache_file_extension}" unless downloader.cache_file_extension.nil?
    
        uri.query.nil? ? path : "#{path}?#{uri.query}"
      end
      
      def self.uri_to_path_lambda
        @uri_to_path_lambda ||= lambda { |downloader, uri| uri_to_path(downloader, uri) }
      end
    end
  end
end
