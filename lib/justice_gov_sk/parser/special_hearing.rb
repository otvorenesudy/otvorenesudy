# encoding: utf-8

module JusticeGovSk
  class Parser
    class SpecialHearing < JusticeGovSk::Parser::Hearing
      def commencement_date(document)
        find_value_by_label 'commencement date', document, 'Dátum započatia' do |div|
          JusticeGovSk::Normalizer.datetime(div.text)
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
        find_value_by_label 'chair judge', document, 'Predseda senátu', verbose: false do |div|
          JusticeGovSk::Normalizer.person_name_parted(div.text)
        end
      end
      
      def defendant(document)
        find_value_by_label 'defendant', document, 'Obžalovaný/á' do |div|
          JusticeGovSk::Normalizer.punctuation(div.text)
        end
      end
    end
  end
end
