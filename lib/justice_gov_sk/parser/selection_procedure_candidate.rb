module JusticeGovSk
  class Parser
    class SelectionProcedureCandidate < JusticeGovSk::Parser
      include JusticeGovSk::Helper::Normalizer

      def name(document)
        normalize_person_name(name_unprocessed(document))
      end

      def name_unprocessed(document)
        document.css('.DetailTable')[0].css('.hodnota')[0].text.strip.presence
      end

      def accomplished_expectations(document)
        document.css('.DetailTable')[0].css('.hodnota')[1].text.strip.presence
      end

      def written_score(document)
        document.css('.DetailTable')[0].css('.hodnota')[2].text.strip.presence
      end

      def written_result(document)
        document.css('.DetailTable')[0].css('.hodnota')[3].text.strip.presence
      end

      def oral_score(document)
        document.css('.DetailTable')[0].css('.hodnota')[4].text.strip.presence
      end

      def oral_result(document)
        document.css('.DetailTable')[0].css('.hodnota')[5].text.strip.presence
      end

      def score(document)
        document.css('.DetailTable')[0].css('.hodnota')[6].text.strip.presence
      end

      def position(document)
        document.css('.DetailTable')[0].css('.hodnota')[7].text.strip.presence
      end

      def application_url(document)
        document.css('.DetailTable')[0].css('.hodnota')[8].css('a')[0][:href].strip.presence
      end

      def curriculum_url(document)
        document.css('.DetailTable')[0].css('.hodnota')[9].css('a')[0][:href].strip.presence
      end

      def motivation_letter_url(document)
        document.css('.DetailTable')[0].css('.hodnota')[10].css('a')[0][:href].strip.presence
      end

      def declaration_url(document)
        document.css('.DetailTable')[0].css('.hodnota')[11].css('a')[0][:href].strip.presence
      end
    end
  end
end
