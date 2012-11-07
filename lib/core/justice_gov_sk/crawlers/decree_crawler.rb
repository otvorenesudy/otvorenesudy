module JusticeGovSk
  module Crawlers
    class DecreeCrawler < Crawler
      include Factories
      include Identify
      include Pluralize 
      
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::DecreeParser.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        document = @parser.parse(content)
                
        @decree = decree_factory.find_or_create(uri)
        
        @decree.uri = uri    

        @decree.case_number  = @parser.case_number(document)
        @decree.file_number  = @parser.file_number(document)
        @decree.date         = @parser.date(document)
        @decree.ecli         = @parser.ecli(document)
        
        proceeding(document)
        court(document)
        judge(document)
        
        form(document)
        nature(document)
        
        legislation_area(document)
        legislation_subarea(document)
        
        legislations(document)
        legislation_usages(document)
        
        @persistor.persist(@decree)
      end
      
      def proceeding(document)
      end
      
      def court(document)
      end  
        
      def judge(document)
        name = @parser.judge(document)
        
        unless name.nil?
          judge = judge_factory.find(name)
          
          @decree.judge = judge          
        end
      end
        
      def form(document)
        value = @parser.form(document)
        
        unless value.nil?
          form = decree_form_factory.find_or_create(value)
          
          form.value = value
          
          @persistor.persist(form) if form.id.nil?
          
          @decree.form = form          
        end
      end
      
      def nature(document)
        value = @parser.nature(document)
        
        unless value.nil?
          nature = decree_nature_factory.find_or_create(value)
          
          nature.value = value
          
          @persistor.persist(nature) if nature.id.nil?
          
          @decree.nature = nature          
        end
      end
        
      def legislation_area(document)
      end
      
      def legislation_subarea(document)
      end
        
      def legislations(document)
      end
      
      private
      
      def legislation_usages
      end
    end
  end
end
