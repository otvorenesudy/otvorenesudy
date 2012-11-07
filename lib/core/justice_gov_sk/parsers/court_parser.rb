# encoding: utf-8

module JusticeGovSk
  module Parsers
    class CourtParser < JusticeGovSk::Parsers::Parser
      def type(document)
        name(document).split(/\s/)[0]
      end
      
      def municipality_name(document)
        find_value_by_group_and_index 'municipality name', document, 'Kontakt', 3 do |div|
          div.text.strip
        end
      end
      
      def municipality_zipcode(document)
        find_value_by_group_and_index 'municipality zipcode', document, 'Kontakt', 2 do |div|
          div.text.strip
        end
      end
      
      def name(document)
        return @name unless @name.nil?
        
        find_value_by_group_and_index 'name', document, 'Kontakt', 0 do |div|
          @name ||= div.text.strip
        end
      end
      
      def street(document)
        find_value_by_group_and_index 'street', document, 'Kontakt', 1 do |div|
          div.text.strip
        end
      end
      
      def phone(document)
        find_value_by_group_and_index 'phone', document, 'Kontakt', 4 do |div|
          div.text.strip
        end
      end
     
      def fax(document)
        find_value_by_group_and_index 'fax', document, 'Kontakt', 5 do |div|
          div.text.strip
        end
      end
      
      def media_person(document)
        find_value_by_group_and_index 'media person', document, 'Kontakt pre médiá', 0 do |div|
          div.text.strip
        end 
      end
      
      def media_phone(document)
        find_value_by_group_and_index 'media phone', document, 'Kontakt pre médiá', 1 do |div|
          div.text.strip
        end 
      end
      
      def office_phone(type, document)
        find_value_by_group_and_index office_type_to_name(type) + ' phone', document, office_type_to_group(type), 0 do |div|
          div.text.strip
        end         
      end

      def office_email(type, document)
        find_value_by_group_and_index office_type_to_name(type) + ' email', document, office_type_to_group(type), 1 do |div|
          div.text.strip
        end                 
      end

      def office_hours(type, document)
        group = office_type_to_group(type)
        name  = office_type_to_name(type)
        
        hours = {}
        
        find_value_by_group_and_index(name + ' monday hours',    document, group, 3) { |div| hours[:monday]    = div.text.strip }
        find_value_by_group_and_index(name + ' tuesday hours',   document, group, 4) { |div| hours[:tuesday]   = div.text.strip }
        find_value_by_group_and_index(name + ' wednesday hours', document, group, 5) { |div| hours[:wednesday] = div.text.strip }
        find_value_by_group_and_index(name + ' thursday hours',  document, group, 6) { |div| hours[:thursday]  = div.text.strip }
        find_value_by_group_and_index(name + ' friday hours',    document, group, 7) { |div| hours[:friday]    = div.text.strip }
        
        hours       
      end

      def office_note(type, document)
        find_value_by_group_and_index office_type_to_name(type) + ' note', document, office_type_to_group(type), 2 do |div|
          div.text.strip
        end         
      end
      
      def latitude(document)
        coordinates(document)[:latitude]
      end
      
      def longitude(document)
        coordinates(document)[:longitude]
      end
      
      private
      
      def office_type_to_group(type)
        case type 
        when :information_center
            'Informačné centrum'
        when :registry_center
            'Podateľňa'
        when :business_registry_center
            'Informačné stredisko obchodného registra'
        end
      end
      
      def office_type_to_name(type)
        type.to_s.gsub(/\_/, ' ')
      end
      
      def coordinates(document)
        return @coordinates unless @coordinates.nil? 
        
        find_value 'coordinates', document, 'div.textInfo iframe' do |iframe|
          @coordinates = {}
                      
          iframe[0][:src].scan(/sll=(\d+\.\d{6})\,(\d+\.\d{6})/) do |latitude, longitude|
            @coordinates[:latitude]  = latitude.sub(/\./, '')
            @coordinates[:longitude] = longitude.sub(/\./, '')
          end
          
          @coordinates
        end
      end
    end
  end
end
