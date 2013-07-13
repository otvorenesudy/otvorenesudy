module NrsrSk
  class Processor
    class JudgeDesignations < NrsrSk::Processor
      include Core::Processor::CSV

      include JusticeGovSk::Helper::JudgeMatcher

      def initialize
        @parser = NrsrSk::Parser::JudgeDesignation.new
      end

      def process(filepath, options = {})
        read(filepath, options) do |record|
          @parser.parse(record)

          judge_name = @parser.judge
          judges_map = match_judges_by(judge_name)

          matched_similarity, matched_judges = judges_map.first

          next if matched_similarity != 1.0 || matched_judges.blank? || matched_judges.count > 1

          judge = matched_judges.first
          date  = @parser.date

          @designation = judge_designation_by_judge_id_and_date_factory.find_or_create(judge.id, date)

          if @parser.designation_type
            @designation_type = judge_designation_type_by_value_factory.find_or_create(@parser.designation_type)

            @designation_type.value = @parser.designation_type

            persist(@designation_type)
          end

          @designation.judge  = judge
          @designation.date   = date
          @designation.type   = @designation_type
          @designation.source = options[:source] || NrsrSk.source
          @designation.uri    = @filepath

          persist(@designation)
        end
      end
    end
  end
end
