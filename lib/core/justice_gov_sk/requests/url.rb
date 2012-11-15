module JusticeGovSk
  module Requests
    module URL
      def self.base
        'http://www.justice.gov.sk'
      end

      def self.headers
        {
          'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          'Accept-Language' => 'en-US,en;q=0.5',
          'Accept-Encoding' => 'gzip, deflate',
          'Cache-Control'   => 'max-age=0',
          'DNT'             => '1',
          'Connection'      => 'keep-alive',
          'Cookie'          => '__utma=161066278.1871589972.1351081154.1352917575.1352943059.48; __utmz=161066278.1351118484.7.3.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=mssr; ASP.NET_SessionId=t4koyt45ztxjll55ls3cr5z0; __utmc=161066278; __utmb=161066278.1.10.1352943059',
          'Host'            => 'www.justice.gov.sk',
          'User-Agent'      => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:16.0) Gecko/20100101 Firefox/16.0'
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
