module JusticeGovSk
  class Processor
    class Paragraphs < JusticeGovSk::Processor
      def initialize
        @parser = inject JusticeGovSk::Parser::Paragraph
      end

      def process(filepath, options = {})
        super(filepath, options) do |record|
          @parser.parse(record)

          @paragraph = paragraph_by_number_factory.find_or_create(@parser.number)

          @paragraph.legislation = @parser.legislation
          @paragraph.number      = @parser.number
          @paragraph.description = @parser.description

          persist(@paragraph)
        end
      end
    end
  end
end
