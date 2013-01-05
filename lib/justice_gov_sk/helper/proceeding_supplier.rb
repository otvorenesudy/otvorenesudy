module JusticeGovSk
  module Matcher
    module Proceeding
      def match_proceeding_by(file_number)
        proceeding = proceeding_by_file_number_factory.find_or_create(file_number)
        
        proceeding.file_number = file_number
        
        yield proceeding
      end
      
      def match_and_process_proceeding_for(instance)
        match_proceeding_by(instance.file_number) do |proceeding|
          persistor.persist(proceeding) if proceeding.id.nil?
          
          instance.proceeding = proceeding
        end
      end
    end
  end
end
