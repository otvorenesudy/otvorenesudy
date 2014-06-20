module JusticeGovSk
  class Parser
    class SelectionProcedure < JusticeGovSk::Parser
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
        document.css('.DetailTable')[0].css('.hodnota')[1].text.strip
      end

      def workplace(document)
        document.css('.DetailTable')[0].css('.hodnota')[3].text.strip.squeeze(' ').presence
      end

      def place(document)
        document.css('.DetailTable')[0].css('.hodnota')[10].try(:text).to_s.strip.squeeze(' ').presence
      end

      def state(document)
        document.css('.DetailTable')[0].css('.hodnota')[5].text.strip.squeeze(' ')
      end

      def date(document)
        Time.parse(document.css('.DetailTable')[0].css('.hodnota')[9].text) rescue nil
      end

      def closed_at(document)
        Time.parse(document.css('.DetailTable')[0].css('.hodnota')[4].text)
      end

      def description(document)
        document.css('.DetailTable')[0].css('.hodnota')[11].try(:text).to_s.strip.presence
      end

      def declaration_url(document)
        document.css('.DetailTable')[0].css('.hodnota')[6].css('a')[0]['href']
      end

      def report_url(document)
        document.css('.DetailTable')[0].css('.hodnota')[7].css('a')[0]['href']
      end

      def candidates_urls(document)

      end

      def commissioners(document)
        value = document.css('.DetailTable')[0].css('.hodnota')[8].try(:text).to_s

        CommissionersParser.parse(value)
      end

      class CommissionersParser
        extend JusticeGovSk::Helper::Normalizer

        def self.parse(value)
          if value.match(/\d+\./)
            values = value.split(/\d+\./).map { |name|
              name = name.strip

              next if name.blank? || name =~ /posledný člen bude zvolený sudcovskou radou/i

              name.strip
            }.compact
          else
            replacements = ['PhD', 'CSc']

            replacements.each do |replacement|
              value.gsub!(/,\s*#{replacement}/, "-#{replacement}")
            end

            values = value.split(/[;,]/)

            values.map! do |name|
              replacements.each do |replacement|
                name.gsub!(/-#{replacement}/, ", #{replacement}")
              end

              name.strip
            end
          end

          values.map do |name|
            unprocessed = name
            name        = normalize_person_name(name.gsub(/-\s*\p{Word}+\s*zvolen[ýá] .+\z/i, ''))

            { name: name, unprocessed: unprocessed }
          end
        end
      end
    end
  end
end
