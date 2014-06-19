module JusticeGovSk
  class Parser
    class SelectionProcedure < JusticeGovSk::Parser
      include JusticeGovSk::Helper::Normalizer

      def organization_name_unprocessed(document)
        document.css('.DetailTable')[0].css('.hodnota')[0].text.strip
      end

      def organization_name(document)
        normalize_court_name(organization_name_unprocessed(document))
      end

      def organization_description(document)
        document.css('.DetailTable')[0].css('.hodnota')[2].text.strip
      end

      def position(document)
        document.css('.DetailTable')[0].css('.hodnota')[1].text.strip
      end

      def workplace(document)
        document.css('.DetailTable')[0].css('.hodnota')[3].text.strip.squeeze(' ')
      end

      def place(document)
        document.css('.DetailTable')[0].css('.hodnota')[10].text.strip.squeeze(' ')
      end

      def state(document)
        document.css('.DetailTable')[0].css('.hodnota')[9].text.strip.squeeze(' ')
      end
    end
  end
end
