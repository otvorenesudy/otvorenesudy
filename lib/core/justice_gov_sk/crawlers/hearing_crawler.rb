module JusticeGovSk
  module Crawlers
    class HearingCrawler < Crawler
      include Factories
      include Identify
      include Pluralize 
      
      def initialize(downloader, parser, persistor)
        super(downloader, parser, persistor)
      end
      
      protected
      
      def process(uri, content)
        raise
      end
    
      def preprocess(uri, content)
        document = @parser.parse(content)
                
        @hearing = hearing_factory.find_or_create(uri)
        
        @hearing.uri = uri

        @hearing.case_number  = @parser.case_number(document)
        @hearing.file_number  = @parser.file_number(document)
        @hearing.date         = @parser.date(document)
        @hearing.room         = @parser.room(document)
        @hearing.note         = @parser.note(document)
      
        proceeding(document)
        court(document)
        
        type(document)
        section(document)
        subject(document)
        form(document)
        
        document
      end
      
      def proceeding(document)
      end
      
      def court(document)
        name = @parser.court(document)
        
        unless name.nil?
          court = court_factory { Court.similar_by_name(name, 0.65) }.find
          
          @hearing.court = court
        end
      end
      
      def judges(document)
        names = @parser.judges(document)
    
        unless names.empty?
          puts "Processing #{pluralize names.count, 'judge'}."
          
          names.each do |name|
            judge = judge_factory.find(name)
            
            judging(judge)
          end
        end
      end
      
      def type(document)
        value = @parser.type(document)
        
        unless value.nil?
          type = hearing_type_factory.find_or_create(value)
          
          type.value = value
          
          @persistor.persist(type) if type.id.nil?
          
          @hearing.type = type          
        end
      end
      
      def section(document)
        value = @parser.section(document)
        
        unless value.nil?
          section = hearing_section_factory.find_or_create(value)
          
          section.value = value
          
          @persistor.persist(section) if section.id.nil?
          
          @hearing.section = section
        end
      end
      
      def subject(document)
        value = @parser.subject(document)
        
        unless value.nil?
          subject = hearing_subject_factory.find_or_create(value)
          
          subject.value = value
          
          @persistor.persist(subject) if subject.id.nil?
          
          @hearing.subject = subject
        end
      end
      
      def form(document)
        value = @parser.form(document)
        
        unless value.nil?
          form = hearing_form_factory.find_or_create(value)
          
          form.value = value
          
          @persistor.persist(form) if form.id.nil?
          
          @hearing.form = form          
        end
      end
    end
  end
end
