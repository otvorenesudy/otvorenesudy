module JusticeGovSk
  module Crawlers
    class CriminalHearingCrawler < HearingCrawler
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::CriminalHearingParser.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        document = preprocess(uri, content)

        judges(document)

        defendants(document)
        
        @persistor.persist(@hearing)
      end
      
      def defendants(document)
        map = @parser.defendants(document)
    
        unless map.empty?
          puts "Processing #{pluralize map.size, 'defendant'}."
          
          map.each do |name, values|
            defendant = defendant_factory.find_or_create(@hearing.id, name)
            
            defendant.hearing = @hearing
            defendant.name    = name
            
            @persistor.persist(defendant) if defendant.id.nil?
            
            accusations(defendant, values)
          end
        end
      end
      
      private
      
      def accusations(defendant, values)
        unless values.empty?
          puts "Processing #{pluralize values.count, 'accusation'}."
          
          values.each do |value|
            accusation = accusation_factory.find_or_create(defendant.id, value)
            
            accusation.defendant = defendant
            accusation.value     = @parser.accusation(value)
            
            @persistor.persist(accusation) if accusation.id.nil?
          end         
        end
      end
    end
  end
end
