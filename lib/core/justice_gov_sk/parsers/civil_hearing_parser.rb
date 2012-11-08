# encoding: utf-8

module JusticeGovSk
  module Parsers
    class CivilHearingParser < HearingParser
      def type(document)
        'Civilné'
      end
      
      def special_type(document)
        find_value_by_label 'special type', document, 'Typ' do |div|
          div.text.strip
        end
      end
      
      def court(document)
        find_value_by_label 'court', document, 'Súd' do |div|
          div.text.strip
        end
      end
      
      def judges(document)
        find_rows_by_group 'judges', document, 'Sudcovia' do |divs|
          names = []
          
          divs.each_with_index do |div, i|
            if div[:class] == 'popiska' && div.text.blank? && divs[i + 1][:class] == 'hodnota'
              names << divs[i + 1].text.strip
            end
          end
          
          names
        end
      end
        
      def proposers(document)
      end

      def opponents(document)
      end
    end
  end
end
