# encoding: utf-8

module JusticeGovSk
  module Parser
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
            position: position(td[2].text.strip),
            active:   activity(td[0]),
            note:     note(td[4].text.strip)
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
        JusticeGovSk::Helpers::NormalizeHelper.court_name(value)
      end

      def name(value)
        JusticeGovSk::Helpers::NormalizeHelper.person_name_parted(value)
      end

      def position(value)
        value
      end

      def note(value)
        value.gsub(/\A-/, '').strip.squeeze(' ') unless value.blank?
      end
    end
  end
end
