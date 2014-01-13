# encoding: utf-8

module JusticeGovSk
  class Parser
    class CriminalHearing < JusticeGovSk::Parser::Hearing
      def defendants(document)
        find_rows_by_group 'defendants', document, 'Obžalovaní', verbose: false do |divs|
          map  = {}
          name = nil

          divs.each do |div|
            if div[:class] == 'popiska'
              name = { normalized: normalize_participant(div.text), unprocessed: div.text.strip }
              map[name] = []
            elsif div[:class] == 'hodnota'
              value = accusation(div.text)

              map[name] << { normalized: value, unprocessed: div.text.strip } unless value.blank?
            end
          end

          map
        end
      end

      private

      def accusation(value)
        value.strip!
        value.gsub!(/\A\s*\-+/, '')
        value.gsub!(/[eČč][Íí]slo/i, 'č.')
        value.gsub!(/zbierky(\s+z[Áá]konov)?/i, 'Zbierky zákonov')

        normalize_punctuation(value)
      end
    end
  end
end
