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
        value = @parser.legislation_area(document)
        
        unless value.nil?
          legislation_area = legislation_area_factory.find_or_create(value)
          
          legislation_area.value = value
          
          @persistor.persist(legislation_area) if legislation_area.id.nil?
          
          @decree.legislation_area = legislation_area          
        end
      end
      
      def legislation_subarea(document)
        value = @parser.legislation_subarea(document)
        
        unless value.nil?
          legislation_subarea = legislation_subarea_factory.find_or_create(value)

          legislation_area(document) if @decree.legislation_area.nil?
          
          legislation_subarea.area  = @decree.legislation_area
          legislation_subarea.value = value
          
          @persistor.persist(legislation_subarea) if legislation_subarea.id.nil?
          
          @decree.legislation_subarea = legislation_subarea          
        end
      end
        
      def legislations(document)
        list = @parser.legislations(data)
    
        unless list.empty?
          puts "Processing #{pluralize list.count, 'legislation'}."
          
          list.each do |item|
            identifiers = @parser.legislation(item)
            
            unless identifiers.empty?
              value = identifiers[:value]
              
              legislation = legislation_factory.find_or_create(value)
              
              legislation.value     = value
              legislation.original  = item
              
              legislation.number    = identifiers[:number] 
              legislation.year      = identifiers[:year]
              legislation.name      = identifiers[:name]
              legislation.paragraph = identifiers[:paragraph]
              legislation.section   = identifiers[:section]
              legislation.letter    = identifiers[:letter]
              
              @persistor.persist(legislation) if legislation.id.nil?
              
              legislation_usage(legislation)
            end
          end
        end
      end
      
      private
      
      def legislation_usage(legislation)
        legislation_usage = legislation_usage_factory.find_or_create(legislation.id, @decree.id)
        
        legislation_usage.legislation = legislation
        legislation_usage.decree      = @decree
        
        @persistor.persist(legislation_usage) if legislation_usage.id.nil?
      end
    end
  end
end
