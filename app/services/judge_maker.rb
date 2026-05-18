class JudgeMaker
  def make(uri, source, name, optionals = {}, options = {})
    judge = persist_judge(uri, source, name)

    court = optionals[:court]
    court = Court.find_by_name(court) if court && !court.is_a?(Court)

    raise 'No court' if options[:require_court] && court.nil?

    position = optionals[:position]

    if position && !position.is_a?(JudgePosition)
      position = find_or_create_position(position)
    end

    raise 'No position' if options[:require_position] && position.nil?

    if court
      if optionals[:active]
        judge.employments.active.each do |employment|
          employment.update!(active: false)
        end
      end

      find_or_create_employment(court, judge, position, optionals[:active], optionals[:note])
    end

    judge
  end

  private

  def persist_judge(uri, source, name)
    judge = Judge.find_or_initialize_by(name: name[:value])

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

    judge.save!
    judge
  end

  def find_or_create_position(value)
    return if value.nil?

    position = JudgePosition.find_or_initialize_by(value: value)
    position.value = value
    position.save!
    position
  end

  def find_or_create_employment(court, judge, position, active, note)
    employment = Employment.find_or_initialize_by(court_id: court.id, judge_id: judge.id)

    employment.court          = court
    employment.judge          = judge
    employment.judge_position = position
    employment.active         = active
    employment.note           = note

    employment.save!
    employment
  end
end
