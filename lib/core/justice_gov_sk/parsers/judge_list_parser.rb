# encoding: utf-8

module JusticeGovSk
  module Parsers
    class JudgeListParser < JusticeGovSk::Parsers::ListParser
      def list(document)
        find_values 'list', document, 'table.GridTable tr' do |rows|
          rows[1..-2].to_a
        end
      end

      def data(element)
        find_values 'data', element, 'td' do |data|
          {
            court:            court(data[3].text.strip),
            name:             name(data[1].text),
            name_unprocessed: name(data[1].text.strip),
            position:         position(data[2].text.strip),
            active:           activity(data[0]),
            note:             note(data[4].text.strip)
          }
        end
      end

      private

      def activity(element)
        find_value 'activity', element, 'img', empty?: false do |img|
          activity = img.attr('title').text
          !activity.match(/Aktívny/i).nil?
        end
      end

      def court(value)
        value.sub!(/Najvyšší súd SR/i, 'Najvyšší súd Slovenskej republiky')
        value.sub!(/Ústavný súd SR/i,  'Ústavný súd Slovenskej republiky')
        value.sub!(/\s*\-\s*/, ' ')
        value.titlecase
      end

      def name(value)
        JusticeGovSk::Helpers::NormalizeHelper.person_name(value)
      end

      def position(value)
        value
      end

      def note(value)
        value
      end
    end
  end
end
