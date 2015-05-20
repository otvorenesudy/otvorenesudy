module JusticeGovSk
  class Parser
    class SelectionProcedure < JusticeGovSk::Parser
      include JusticeGovSk::Helper::SelectionProcedure

      def organization_name_unprocessed(document)
        document.css('.DetailTable')[0].css('.hodnota')[0].text.strip
      end

      def organization_name(document)
        normalize_court_name(organization_name_unprocessed(document))
      end

      def organization_description(document)
        document.css('.DetailTable')[0].css('.hodnota')[2].text.strip.presence
      end

      def position(document)
        normalize_position(document.css('.DetailTable')[0].css('.hodnota')[1].text.strip)
      end

      def workplace(document)
        document.css('.DetailTable')[0].css('.hodnota')[3].text.strip.squeeze(' ').presence
      end

      def place(document)
        document.css('.DetailTable')[0].css('.hodnota')[11].try(:text).to_s.strip.squeeze(' ').presence
      end

      def state(document)
        document.css('.DetailTable')[0].css('.hodnota')[5].text.strip.squeeze(' ')
      end

      def date(document)
        Time.parse(document.css('.DetailTable')[0].css('.hodnota')[10].text) rescue nil
      end

      def closed_at(document)
        Time.parse(document.css('.DetailTable')[0].css('.hodnota')[4].text)
      end

      def description(document)
        document.css('.DetailTable')[0].css('.hodnota')[12].try(:text).to_s.strip.presence
      end

      def declaration_url(document)
        value = document.css('.DetailTable')[0].css('.hodnota')[6].css('a').try(:[], 0).try(:[], :href).try(:strip).try(:presence)

        "#{JusticeGovSk::URL.base}#{value}" if value
      end

      def report_url(document)
        value = document.css('.DetailTable')[0].css('.hodnota')[7].css('a').try(:[], 0).try(:[], :href).try(:strip).try(:presence)

        "#{JusticeGovSk::URL.base}#{value}" if value
      end

      def candidates_urls(document)
        document.css('.GridTable tr td:nth(5) a').map do |link|
          "#{JusticeGovSk::URL.base}#{link[:href]}"
        end
      end

      def commissioners(document)
        value = document.css('.DetailTable')[0].css('.hodnota')[9].try(:text).to_s

        parse_commissioners(value)
      end
    end
  end
end
