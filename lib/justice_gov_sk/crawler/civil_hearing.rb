module JusticeGovSk
  class Crawler
    class CivilHearing < JusticeGovSk::Crawler::Hearing
      protected

      def process(request)
        super do
          @hearing.type = HearingType.civil
          
          @hearing.special_type = @parser.special_type(@document)
          
          judges
          
          proposers
          opponents

          @hearing
        end
      end
      
      def proposers
        names = @parser.proposers(@document)
    
        unless names.empty?
          puts "Processing #{pluralize names.count, 'proposer'}."
          
          names.each do |name|
            proposer = proposer_by_hearing_id_and_name_factory.find_or_create(@hearing.id, name[:normalized])
            
            proposer.hearing          = @hearing
            proposer.name             = name[:normalized]
            proposer.name_unprocessed = name[:unprocessed]
            
            @persistor.persist(proposer)
          end
        end
      end

      def opponents
        names = @parser.opponents(@document)
    
        unless names.empty?
          puts "Processing #{pluralize names.count, 'opponent'}."
          
          names.each do |name|
            opponent = opponent_by_hearing_id_and_name_factory.find_or_create(@hearing.id, name[:normalized])
            
            opponent.hearing          = @hearing
            opponent.name             = name[:normalized]
            opponent.name_unprocessed = name[:unprocessed]
            
            @persistor.persist(opponent)
          end
        end
      end
    end
  end
end
