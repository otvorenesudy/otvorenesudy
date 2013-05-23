module JusticeGovSk
  class Processor
    class CourtExpenses < JusticeGovSk::Processor
      def initialize
        @parser = inject JusticeGovSk::Parser::CourtExpense
      end

      def process(filename, options = {})
        super(filename, options) do |record|
          @parser.parse(record)

          @court = court_by_name_factory.find @parser.court

          @expense = court_expense_by_court_id_and_year_and_value_factory.find_or_create(@court.id, @parser.year, @parser.value)

          @expense.court  = @court
          @expense.year   = @parser.year
          @expense.value  = @parser.value
          @expense.uri    = @file_uri
          @expense.source = JusticeGovSk.source

          persist(@expense)
        end
      end
    end
  end
end
