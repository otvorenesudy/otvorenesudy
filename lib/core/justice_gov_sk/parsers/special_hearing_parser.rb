# encoding: utf-8

module JusticeGovSk
  module Parsers
    class SpecialHearingParser < HearingParser
      def type(document)
        'Špecializovaného trestného súdu'
      end
      
      def commencement_date(document)
        find_value_by_label 'commencement date', document, 'Dátum započatia' do |div|
          JusticeGovSk::Helpers::NormalizeHelper.datetime(div.text)
        end
      end
      
      def selfjudge(document)
        find_value_by_label 'selfjudge', document, 'Samosudca' do |div|
          !div.text.strip.match(/ano|áno/i).nil?
        end
      end
      
      def court(document)
        'Špecializovaný trestný súd'
      end

      def chair_judge(document)
        find_value_by_label 'chair judge', document, 'Predseda senátu' do |div|
          JusticeGovSk::Helpers::NormalizeHelper.person_name(div.text)
        end
      end
      
      def defendant(document)
        find_value_by_label 'defendant', document, 'Obžalovaný/á' do |div|
          JusticeGovSk::Helpers::NormalizeHelper.punctuation(div.text)
        end
      end
    end
  end
end
