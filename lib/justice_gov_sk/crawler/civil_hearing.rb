module JusticeGovSk
  class Crawler
    class CivilHearing < JusticeGovSk::Crawler::Hearing
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parser::CivilHearing.new, persistor)
      end
      
      protected

      def process(uri, content)
        document = preprocess(uri, content)

        @hearing.type = CivilHearing.type
        
        @hearing.special_type = @parser.special_type(document)
        
        judges(document)
        
        proposers(document)
        opponents(document)
        
        @persistor.persist(@hearing)
      end
      
      # TODO refactor -> common method for proposers and oponents
      
      def proposers(document)
        names = @parser.proposers(document)
    
        unless names.empty?
          puts "Processing #{pluralize names.count, 'proposer'}."
          
          names.each do |name|
            proposer = proposer_by_hearing_id_and_name_factory.find_or_create(@hearing.id, name)
            
            proposer.hearing = @hearing
            proposer.name    = name
            
            @persistor.persist(proposer) if proposer.id.nil?
          end
        end
      end

      def opponents(document)
        names = @parser.opponents(document)
    
        unless names.empty?
          puts "Processing #{pluralize names.count, 'opponent'}."
          
          names.each do |name|
            opponent = opponent_by_hearing_id_and_name_factory.find_or_create(@hearing.id, name)
            
            opponent.hearing = @hearing
            opponent.name    = name
            
            @persistor.persist(opponent) if opponent.id.nil?
          end
        end
      end
    end
  end
end
