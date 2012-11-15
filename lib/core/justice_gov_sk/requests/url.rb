module JusticeGovSk
  module Requests
    module URL
      def self.base
        'http://www.justice.gov.sk'
      end

      def self.headers
        {
          'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          'Accept-Charset'  => 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
          'Accept-Encoding' => 'gzip,deflate,sdch',
          'Accept-Language' => 'en-US,en;q=0.8',
          'Cache-Control'   => 'max-age=0',
          'Connection'      => 'keep-alive',
          'Content-Type'    => 'application/x-www-form-urlencoded',
          'Host'            => 'www.justice.gov.sk',
          'Origin'          => 'http://www.justice.gov.sk',
          'User-Agent'      => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4'
        }
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
        path = "#{path}?#{uri.query}" unless uri.query.nil?
        path = "#{path}.#{downloader.cache_file_extension}" unless downloader.cache_file_extension.nil?
        path
      end
      
      def self.uri_to_path_lambda
        @uri_to_path_lambda ||= lambda { |downloader, uri| uri_to_path(downloader, uri) }
      end
    end
  end
end
