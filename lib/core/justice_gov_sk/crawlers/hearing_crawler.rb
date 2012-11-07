module JusticeGovSk
  module Crawlers
    class HearingCrawler < Crawler
      include Factories
      include Identify
      include Pluralize 
      
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::HearingParser.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        document = @parser.parse(content)
                
        @hearing = hearing_factory.find_or_create(uri)
        
        @hearing.uri = uri

        @hearing.case_number  = @parser.case_number(document)
        @hearing.file_number  = @parser.file_number(document)
        @hearing.date         = @parser.date(document)
        @hearing.room         = @parser.room(document)
        @hearing.note         = @parser.note(document)
      
        proceeding(document)
        type(document)
        section(document)
        subject(document)
        form(document)
      end
      
      def proceeding(document)
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
