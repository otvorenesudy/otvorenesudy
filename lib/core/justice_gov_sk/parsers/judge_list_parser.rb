# encoding: utf-8

module JusticeGovSk
  module Parsers
    class JudgeListParser < JusticeGovSk::Parsers::ListParser
      def list(document)
        find_values 'list', document, 'table.GridTable tr' do |rows|
          values = []

          rows[1..-2].each do |row|
            hash = {} 
            data = data(row)
         
            hash[:active]   = activity(data[0])
            hash[:name]     = name(data[1].text.strip)
            hash[:position] = position(data[2].text.strip)
            hash[:court]    = court(data[3].text.strip)
            hash[:note]     = note(data[4].text.strip)

            values << hash
          end

          values 
        end
      end

      private 

      def data(element)
        find_value 'data', element, 'td'
      end

      def activity(element)
        find_value 'activity', element, 'img', empty?: false do |img|
          activity = img.attr('title').text
          if activity == 'Aktívny' 
            return true
          else 
            return false
          end
        end
      end

      def name(value)
        value
      end

      def position(value)
        value
      end

      def court(value)
        value
      end

      def note(value)
        value
      end
    end
  end
end
