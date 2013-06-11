# encoding: utf-8

module JusticeGovSk
  class Parser
    class JudgeList < JusticeGovSk::Parser::List
      def list(document)
        find_values 'list', document, 'table.GridTable tr', verbose: false do |trs|
          trs[1..-2].to_a
        end
      end

      def data(element)
        find_values 'data', element, 'td', verbose: false do |td|
          {
            court:    court(td[3].text),
            name:     name(td[1].text),
            position: position(td[2].text),
            active:   activity(td[0]),
            note:     note(td[4].text)
          }
        end
      end

      private

      def activity(element)
        img   = element.search('img')
        value = img.attr('title').text
        
        !value.match(/\AAktívny\z/i).nil?
      end

      def court(value)
        normalize_court_name(value)
      end

      def name(value)
        partition_person_name(value)
      end

      def position(value)
        normalize_punctuation(value)
      end

      def note(value)
        normalize_punctuation(value.gsub(/\A\s*\-+/, '')) unless value.blank?
      end
    end
  end
end
