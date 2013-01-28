# encoding: utf-8

module JusticeGovSk
  class Parser
    class CivilHearing < JusticeGovSk::Parser::Hearing
      def special_type(document)
        find_value_by_label 'special type', document, 'Typ' do |div|
          div.text.strip
        end
      end
              
      def proposers(document)
        mark  = false
        names = []
        
        participants(document).each do |div|
          if div[:class] == 'popiska'
            mark = true if div.text == 'Navrhovatelia'
            break       if div.text == 'Odporcovia'
          end

          if mark && div[:class] == 'hodnota'
            names << normalize_punctuation(div.text)
          end
        end
        
        names
      end

      def opponents(document)
        mark  = false
        names = []
        
        participants(document).each do |div|
          if div[:class] == 'popiska'
            mark = true if div.text == 'Odporcovia'
          end

          if mark && div[:class] == 'hodnota'
            names << normalize_punctuation(div.text)
          end
        end
        
        names
      end
      
      protected
      
      def clear
        super
        
        @participants = nil
      end
      
      private
      
      def participants(document)
        @participants ||= find_rows_by_group 'participants', document, 'Účastníci', verbose: false
      end
    end
  end
end
