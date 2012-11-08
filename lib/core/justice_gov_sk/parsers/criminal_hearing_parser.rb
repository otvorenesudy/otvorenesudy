# encoding: utf-8

module JusticeGovSk
  module Parsers
    class CriminalHearingParser < HearingParser
      def type(document)
        'Trestné'
      end
      
      def court(document)
        find_value_by_label 'court', document, 'Súd' do |div|
          div.text.strip
        end
      end
      
      def judges(document)
      end
      
      def judge(name)
      end
      
      def defendants(document)
      end

      def defendant(name)
      end
      
      def accusation(value)
      end
    end
  end
end
