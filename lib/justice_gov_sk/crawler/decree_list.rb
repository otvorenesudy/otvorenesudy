module JusticeGovSk
  class Crawler
    class DecreeList < JusticeGovSk::Crawler::List
      protected
      
      def process(request)
        raise "Decree from code not set" unless request.decree_form_code
        super        
      end
    end
  end
end
