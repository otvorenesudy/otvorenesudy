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
      
      def judges(document)
      end
      
      def judge(name)
      end
        
      def proposers(document)
      end
      
      def proposer(name)
      end

      def opponents(document)
      end
      
      def opponent(name)
      end
    end
  end
end
