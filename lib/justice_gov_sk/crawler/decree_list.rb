module JusticeGovSk
  class Crawler
    class DecreeList < JusticeGovSk::Crawler::List
      protected
      
      def process(request)
        raise "Decree from code not set" unless request.decree_form_code
        
        super(request) do |url|
          crawler = JusticeGovSk::Crawler::Decree.new(decree_form_code: request.decree_form_code)
          
          crawler.crawl url
        end
      end
    end
  end
end
