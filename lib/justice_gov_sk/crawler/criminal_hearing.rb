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
            defendant = defendant_by_hearing_id_and_name_factory.find_or_create(@hearing.id, name[:normalized])
            
            defendant.hearing          = @hearing
            defendant.name             = name[:normalized]
            defendant.name_unprocessed = name[:unprocessed]
            
            @persistor.persist(defendant)
            
            accusations(defendant, values)
          end
        end
      end
      
      private
      
      def accusations(defendant, values)
        unless values.empty?
          puts "Processing #{pluralize values.count, 'accusation'}."
          
          values.each do |value|
            accusation = accusation_by_defendant_id_and_value_factory.find_or_create(defendant.id, value[:normalized])
            
            accusation.defendant         = defendant
            accusation.value             = value[:normalized]
            accusation.value_unprocessed = value[:unprocessed]
            
            accusation.paragraph_explainations = []
            
            @persistor.persist(accusation)
            
            @parser.scan_paragraphs(accusation.value).each do |number|
              paragraph_explaination(number, accusation) if accusation.value.utf8 =~ /č\s*\.\s*300\//i
            end
          end         
        end
      end

      def paragraph_explaination(number, accusation)
        paragraph = paragraph_by_legislation_and_number_factory.find(300, number)
        
        if paragraph
          paragraph_explaination = paragraph_explaination_by_paragraph_id_and_explainable_id_and_explainable_type_factory.find_or_create(paragraph.id, accusation.id, :Accusation)
          
          paragraph_explaination.paragraph   = paragraph
          paragraph_explaination.explainable = accusation
          
          @persistor.persist(paragraph_explaination)
        else
          puts "No known paragraph found."
        end
      end
    end
  end
end
