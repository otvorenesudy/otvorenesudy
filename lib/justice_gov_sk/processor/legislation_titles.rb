module JusticeGovSk
  class Processor
    class LegislationTitles < JusticeGovSk::Processor
      def initialize
        @parser = inject JusticeGovSk::Parser::LegislationTitle
      end

      def process(filepath, options = {})
        super(filepath, options) do |record|
          @parser.parse(record)

          @name = legislation_title_by_paragraph_and_value_factory.find_or_create(@parser.paragraph, @parser.value)

          @name.paragraph = @parser.paragraph
          @name.value     = @parser.value

          persist(@name)
        end
      end
    end
  end
end
