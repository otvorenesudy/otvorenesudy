module JudgesHelper
  def judge_title(judge, options = {}, &block)
    judge_wrap_fix "#{judge.prefix} #{judge.suffix}".strip, judge_activity_options(judge, options), &block
  end

  def judge_activity_icon_tag(judge, active, options = {})
    n, c, t = case active
    when true  then %w(check    text-success judges.activity.active)
    when false then %w(times    text-danger  judges.activity.inactive)
    when nil   then %w(question text-warning judges.activity.unknown)
    end

    options = options.merge class: Array.wrap(options[:class]).unshift("d-inline #{c}")
    options = options.merge placement: options.delete(:placement) || 'top'

    tooltip_tag icon_tag(n, size: options.delete(:size)), t("#{t}.#{judge.probable_gender}").upcase_first, options
  end

  def judge_activity_by_employment(employment, options = {}, &block)
    a = employment.active ? 'active' : 'inactive'
    a = 'unknown' if employment.active.nil?
    s = t "judges.activity.#{a}.#{employment.judge.probable_gender}"
    judge_wrap_fix s, judge_activity_options(employment.judge, options), &block
  end

  def judge_position_at_court(judge, court, options = {}, &block)
    judge_position_by_employment judge.employments.at_court(court).first, options, &block
  end

  def judge_position_by_employment(employment, options = {}, &block)
    tooltip = !(options.delete(:tooltip) === false)
    options = judge_activity_options employment.judge, options

    g = employment.judge.probable_gender

    if employment.judge_position
      if employment.judge_position.charged?
        s = t "judges.position.employee.#{g}"
      else
        if employment.judge_position.value == 'sudca'
          s = t "judges.position.judge.#{g}"
        else
          k = %w(chairman vice_chairman visiting_judge).map { |e| "judges.position.#{e}.#{g}" }
          s = t guess_translation_key(employment.judge_position.value, :sk, k) || employeement.judge_position.value
        end
      end
    else
      if employment.judge.probably_higher_court_official?
        if tooltip
          p = t 'judges.position.higher_court_official.acronym'
          t = t "judges.position.higher_court_official.#{g}"
          c = 'text-muted' if Array.wrap(options[:class]).include? 'text-muted'
          s = "#{t 'judges.position.probably'} #{tooltip_tag p, t.upcase_first, class: c}"
        else
          s = "#{t 'judges.position.probably'} #{t "judges.position.higher_court_official.#{g}"}"
        end
      else
        s = "#{t "judges.position.unknown.#{g}"} #{t "judges.position.employee.#{g}"}"
      end
    end

    judge_wrap_fix s, options, &block
  end

  def judge_hearings_count_by_employment(employment, options = {}, &block)
    count = number_with_delimiter Hearing.during_employment(employment).exact.size
    judge_wrap_fix count, judge_activity_options(employment.judge, options), &block
  end

  def judge_decrees_count_by_employment(employment, options = {}, &block)
    count = number_with_delimiter Decree.during_employment(employment).exact.size
    judge_wrap_fix count, judge_activity_options(employment.judge, options), &block
  end

  def judge_processed_names(relation)
    Judge::Names.from_unprocessed(relation).sort.to_sentence
  end

  def link_to_judge(judge, options = {})
    link_to judge.name(options.delete(:format)), judge_path(judge), judge_activity_options(judge, options)
  end

  def links_to_judges(judges, options = {})
    judges.map { |judge| link_to_judge(judge, options) }.to_sentence.html_safe
  end

  def link_to_related_person(person, options = {})
    person.known_judge? ? link_to_judge(person.to_judge, options) : person.name
  end

  def links_to_related_people(people, options = {})
    people.map { |person| link_to_related_person(person, options) }.to_sentence.html_safe
  end

  private

  def judge_activity_options(judge, options)
    global = options.delete :mute_by_activity
    court = options.delete :mute_by_activity_at
    employment = options.delete :mute_by_activity_on

    classes = Array.wrap(options[:class])
    classes << 'text-muted' if global && !judge.active
    classes << 'text-muted' if court && !judge.active_at(court)
    classes << 'text-muted' if employment && !employment.active
    options.merge class: classes
  end

  def judge_wrap_fix(content, options)
    content = yield content if block_given?
    wrap = %i(id class data).find { |k| options[k].present? }
    wrap ? content_tag(:span, content.html_safe, options) : content.html_safe
  end
end
