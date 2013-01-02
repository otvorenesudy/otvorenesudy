module JusticeGovSk
  class Crawler
    class CriminalHearing < JusticeGovSk::Crawler::Hearing
      protected
    
      def process(request)
        super do
          @hearing.type = HearingType.criminal
  
          judges
  
          defendants
          
          @hearing
        end
      end
      
      def defendants
        map = @parser.defendants(@document)
    
        unless map.empty?
          puts "Processing #{pluralize map.size, 'defendant'}."
          
          map.each do |name, values|
            defendant = defendant_by_hearing_id_and_name_factory.find_or_create(@hearing.id, name)
            
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
            accusation = accusation_by_defendant_id_and_value_factory.find_or_create(defendant.id, value)
              
            accusation.defendant = defendant
            accusation.value     = value
              
            @persistor.persist(accusation) if accusation.id.nil?
          end         
        end
      end
    end
  end
end
