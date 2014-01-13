module JusticeGovSk
  module Helper
    module JudgeMaker
      include Core::Factories

      def make_judge(uri, source, name = nil, optionals = {}, options = {})
        judge = prepare_judge uri, source, name

        @persistor.persist(judge)

        court = optionals[:court]

        if court && !court.is_a?(Court)
          court = court_by_name_factory.find(court)
        end

        raise "No court" if options[:require_court] && court.nil?

        position = optionals[:position]

        if position && !position.is_a?(JudgePosition)
          position = prepare_judge_position(position)

          @persistor.persist(position)
        end

        raise "No position" if options[:require_position] && position.nil?

        if court
          employment = prepare_employment(court, judge, position, optionals[:active], optionals[:note])

          @persistor.persist(employment)
        end

        judge
      end

      def prepare_judge(uri, source, name)
        judge = judge_by_name_factory.find_or_create(name[:value])

        judge.uri    = uri
        judge.source = source

        judge.name             = name[:value]
        judge.name_unprocessed = name[:unprocessed]

        judge.prefix   = name[:prefix]
        judge.first    = name[:first]
        judge.middle   = name[:middle]
        judge.last     = name[:last]
        judge.suffix   = name[:suffix]
        judge.addition = name[:addition]

        judge
      end

      def prepare_judge_position(value)
        unless value.nil?
          judge_position = judge_position_by_value_factory.find_or_create(value)

          judge_position.value = value

          judge_position
        end
      end

      def prepare_employment(court, judge, position, active, note)
        employment = employment_by_court_id_and_judge_id_factory.find_or_create(court.id, judge.id)

        employment.court          = court
        employment.judge          = judge
        employment.judge_position = position
        employment.active         = active
        employment.note           = note

        employment
      end
    end
  end
end
