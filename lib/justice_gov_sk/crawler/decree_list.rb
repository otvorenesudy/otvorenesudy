module JusticeGovSk
  class Crawler
    class DecreeList < JusticeGovSk::Crawler::List
      protected
      
      def process(request)
        raise "Decree from code not set" unless request.decree_form
        
        super(request) do |url|
          crawler = JusticeGovSk::Crawler::Decree.new(decree_form: request.decree_form)
          
          crawler.crawl url
        end
      end
    end
  end
end
