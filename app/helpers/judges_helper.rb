# encoding: utf-8

module JudgesHelper
  def judge_name(judge, format = nil)
    return judge.name if format.nil? || format == '%p %f %m %l %a, %s'

    parts = {
      '%p' => judge.prefix,
      '%f' => judge.first,
      '%m' => judge.middle,
      '%l' => judge.last,
      '%s' => judge.suffix,
      '%a' => judge.addition
    }

    format.gsub(/\%[pfmlsa]/, parts).gsub(/(\W)\s+\z/, '').squeeze(' ')
  end

  def judge_titles(judge, options = {})
    content_tag :span, "#{judge.prefix} #{judge.suffix}".strip, judge_options(judge, options)
  end

  
  def judge_activity(status)
    return 'Aktívny'   if status == true
    return 'Neaktívny' if status == false
    return 'Neznámy'   if status == nil
    raise
  end
  
  def judge_activity_icon_tag(status)
    return icon_tag(:'ok-sign')      if status == true
    return icon_tag(:'circle-blank') if status == false
    return icon_tag(:question)       if status == nil
    raise
  end
  
  def judge_activity_tag(status, options = {})
    options  = { tooltip: true }.merge options
    icon_tag = judge_activity_icon_tag(status)
    activity = judge_activity(status)
    
    return icon_tag unless options[:tooltip]
    
    case status
    when true
      tooltip_tag icon_tag, activity, placement: :left, class: :'muted undecorated'
    when false
      tooltip_tag icon_tag, activity, placement: :left, class: :'muted undecorated'
    else
      tooltip_tag icon_tag, activity, placement: :left, class: :'muted undecorated'
    end
  end

  def judge_position(employment)
    options = employment.active ? {} : { class: :muted }

    if employment.judge_position
      tooltip_tag employment.judge_position.value, employment.active ? 'Aktívny' : 'Neaktívny', options.merge(placement: :left)
    else
      if employment.judge.probably_superior_court_officer?
        content_tag :span, options.clone do
          ('pravdepodobne ' + tooltip_tag('VSÚ', 'Vyšší súdny úradník', options)).html_safe
        end
      else
        'neznáma'
      end
    end
  end

  def judge_at_court_employment(judge, court)
    judge.employments.at_court(court).first
  end

  def judge_at_court_position(judge, court)
    judge_at_court_employment(judge, court).judge_position.value
  end

  def judge_hearings_count_by_employment(employment, options = {})
    content_tag :span, number_with_delimiter(Hearing.during_employment(employment).count), employment.active ? {} : { class: :muted }
  end

  def judge_decrees_count_by_employment(employment, options = {})
    content_tag :span, number_with_delimiter(Decree.during_employment(employment).count), employment.active ? {} : { class: :muted }
  end

  def judge_designation_date_tag(designation)
    tooltip_tag icon_tag(:calendar), localize(designation.date, format: :long), placement: :left, class: :'muted undecorated'
  end

  def judge_designation_date_distance(designation)
    tooltip_tag distance_of_time_in_words_to_now(designation.date), localize(designation.date, format: :long)
  end
  
  def link_to_judge(judge, options = {})
    link_to judge_name(judge, options.delete(:format)), judge_path(judge.id), judge_options(judge, options)
  end

  def links_to_judges(judges, options = {})
    separator = options.delete(:separator) || ', '

    judges.map { |judge| link_to_judge(judge, options) }.join(separator).html_safe
  end

  def link_to_institution(institution, options = {})
    link_to_court(institution, options) if Court.where(name: institution).first 
    
    institution
  end

  def link_to_related_person(person, options = {})
    return link_to_judge(person, options) if person.known_judge?

    person.name
  end

  def links_to_related_persons(persons, options = {})
    separator = options.delete(:separator) || ', '

    persons.map { |person| link_to_related_person(person, options) }.join(separator).html_safe
  end

  private

  def judge_options(judge, options)
    options.merge! judge.active ? {} : { class: :muted } if options.delete :adjust_by_activity
    options.merge! judge.active_at(options.delete :adjust_by_activity_at) ? {} : { class: :muted } if options.key? :adjust_by_activity_at
    options
  end
end
