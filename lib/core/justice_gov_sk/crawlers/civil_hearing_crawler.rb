module JusticeGovSk
  module Crawlers
    class CivilHearingCrawler < HearingCrawler
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::CivilHearingParser.new, persistor)
      end
      
      protected

      def process(uri, content)
        document = preprocess(uri, content)

        @hearing.special_type = @parser.special_type(document)
        
        judges(document)
        
        proposers(document)
        opponents(document)
        
        @persistor.persist(@hearing)
      end
      
      def judges(document)
        names = @parser.judges(document)
    
        unless names.empty?
          puts "Processing #{pluralize names.count, 'judges'}."
          
          names.each do |name|
            judge = judge_factory.find(name)
            
            unless judge.nil?
              judging(judge)
            end
          end
        end
      end
        
      def proposers(document)
      end

      def opponents(document)
      end
      
      private
      
      def judging(judge)
        judging = judging_factory.find_or_create(judging.id, @hearing.id)
        
        judging.judge   = judge
        judging.hearing = @hearing
        
        @persistor.persist(judging) if judging.id.nil?
      end
    end
  end
end
