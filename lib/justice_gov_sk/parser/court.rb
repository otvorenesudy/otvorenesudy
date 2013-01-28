# encoding: utf-8

module JusticeGovSk
  class Parser
    class Court < JusticeGovSk::Parser
      def type(document)
        name(document).split(/\s/).first
      end
      
      def municipality_name(document)
        find_value_by_group_and_index 'municipality name', document, 'Kontakt', 3 do |div|
          normalize_municipality_name(div.text)
        end
      end
      
      def municipality_zipcode(document)
        find_value_by_group_and_index 'municipality zipcode', document, 'Kontakt', 2 do |div|
          normalize_zipcode(div.text)
        end
      end
      
      def name(document)
        @name ||= find_value_by_group_and_index 'name', document, 'Kontakt', 0 do |div|
          normalize_court_name(div.text)
        end
      end
      
      def street(document)
        find_value_by_group_and_index 'street', document, 'Kontakt', 1 do |div|
          normalize_street(div.text)
        end
      end
      
      def phone(document)
        find_value_by_group_and_index 'phone', document, 'Kontakt', 4 do |div|
          normalize_phone(div.text)
        end
      end
     
      def fax(document)
        find_value_by_group_and_index 'fax', document, 'Kontakt', 5 do |div|
          normalize_phone(div.text)
        end
      end
      
      def media_person(document)
        @media_person ||= find_value_by_group_and_index 'media person', document, 'Kontakt pre médiá', 0, verbose: false do |div|
          {
            name:             normalize_person_name(div.text),
            name_unprocessed: div.text.strip
          }
        end
      end
      
      def media_phone(document)
        find_value_by_group_and_index 'media phone', document, 'Kontakt pre médiá', 1 do |div|
          normalize_phone(div.text)
        end 
      end
      
      def office_phone(type, document)
        find_value_by_group_and_index office_type_to_name(type) + ' phone', document, type.value, 0 do |div|
          normalize_phone(div.text)
        end         
      end

      def office_email(type, document)
        find_value_by_group_and_index office_type_to_name(type) + ' email', document, type.value, 1 do |div|
          normalize_email(div.text)
        end                 
      end

      def office_hours(type, document)
        group = type.value
        name  = office_type_to_name(type)
        
        hours = {
          monday:    office_daily_hours(name + ' monday hours',    document, group, 3),
          tuesday:   office_daily_hours(name + ' tuesday hours',   document, group, 4),
          wednesday: office_daily_hours(name + ' wednesday hours', document, group, 5),
          thursday:  office_daily_hours(name + ' thursday hours',  document, group, 6),
          friday:    office_daily_hours(name + ' friday hours',    document, group, 7)
        }
        
        hours.values.each { |value| return hours unless value.nil? }
        
        nil
      end
      
      def office_note(type, document)
        find_value_by_group_and_index office_type_to_name(type) + ' note', document, type.value, 2 do |div|
          div.text.strip.squeeze(' ')
        end         
      end
      
      def latitude(document)
        coordinates(document)[:latitude]
      end
      
      def longitude(document)
        coordinates(document)[:longitude]
      end
      
      protected
      
      def clear
        super
        
        @name         = nil
        @media_person = nil
        @coordinates  = nil
      end
      
      private
      
      def office_type_to_name(type)
        type.name.to_s.gsub(/\_/, ' ')
      end
      
      def office_daily_hours(name, document, group, index)
        find_value_by_group_and_index name, document, group, index do |div|
           normalize_hours(div.text)
        end
      end
      
      def coordinates(document)
        @coordinates ||= find_value 'coordinates', document, 'div.textInfo iframe', empty?: false, verbose: false do |iframe|
          data   = iframe.first[:src].scan(/(\&|s)ll=(\-?\d+\.\d+)\,(\-?\d+\.\d+)/)
          values = data.select { |v| v.first == '&' }.first
          values = data.first if values.blank?
          
          { latitude: values[1], longitude: values[2] }
        end
      end
    end
  end
end
