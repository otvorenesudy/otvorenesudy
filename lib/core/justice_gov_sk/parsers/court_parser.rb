# encoding: utf-8

module JusticeGovSk
  module Parsers
    class CourtParser < HtmlParser
      def type(document)
        name(document).split(/\s/)[0]
      end
      
      def municipality_name(document)
        value_from_group document, 'Kontakt', 3, 'municipality name' do |div|
          div.text.strip
        end
      end
      
      def municipality_zipcode(document)
        value_from_group document, 'Kontakt', 2, 'municipality zipcode' do |div|
          div.text.strip
        end
      end
      
      def name(document)
        return @name unless @name.nil?
        
        value_from_group document, 'Kontakt', 0, 'name' do |div|
          @name ||= div.text.strip
        end
      end
      
      def street(document)
        value_from_group document, 'Kontakt', 1, 'street' do |div|
          div.text.strip
        end
      end
      
      def phone(document)
        value_from_group document, 'Kontakt', 4, 'phone' do |div|
          div.text.strip
        end
      end
     
      def fax(document)
        value_from_group document, 'Kontakt', 5, 'fax' do |div|
          div.text.strip
        end
      end
      
      def media_person(document)
        value_from_group document, 'Kontakt pre médiá', 0, 'media person' do |div|
          div.text.strip
        end 
      end
      
      def media_phone(document)
        value_from_group document, 'Kontakt pre médiá', 1, 'media phone' do |div|
          div.text.strip
        end 
      end
      
      def office_phone(type, document)
        value_from_group document, office_type_to_group(type), 0, office_type_to_name(type) + ' phone' do |div|
          div.text.strip
        end         
      end

      def office_email(type, document)
        value_from_group document, office_type_to_group(type), 1, office_type_to_name(type) + ' email' do |div|
          div.text.strip
        end                 
      end

      def office_hours(type, document)
        group = office_type_to_group(type)
        name  = office_type_to_name(type)
        
        hours = {}
        
        value_from_group(document, group, 3, name + ' monday hours')    { |div| hours[:monday]    = div.text.strip }
        value_from_group(document, group, 4, name + ' tuesday hours')   { |div| hours[:tuesday]   = div.text.strip }
        value_from_group(document, group, 5, name + ' wednesday hours') { |div| hours[:wednesday] = div.text.strip }
        value_from_group(document, group, 6, name + ' thursday hours')  { |div| hours[:thursday]  = div.text.strip }
        value_from_group(document, group, 7, name + ' friday hours')    { |div| hours[:friday]    = div.text.strip }
        
        hours       
      end

      def office_note(type, document)
        value_from_group document, office_type_to_group(type), 2, office_type_to_name(type) + ' note' do |div|
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
      
      def value_from_group(document, group, k, name, &block)
        @rows   ||= values document, 'div.DetailTable div', 'information table, all rows'
        @values ||= values document, 'div.DetailTable div.hodnota', 'information table, values only'
        
        group = group.utf8.downcase!
        
        i = 0
        
        @rows.each do |div|
          i += 1 if div[:class] == 'hodnota'
          break if div[:class] == 'skupina' && div.text.utf8.downcase == group
        end
        
        value @values[i + k], '', name, &block
      end
      
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
        
        value document, 'div.textInfo iframe', 'coordinates' do |iframe|
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
