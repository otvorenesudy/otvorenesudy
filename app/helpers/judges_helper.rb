# encoding: utf-8

module JudgesHelper
  def judge_activity_tag(status)
    if status == true || (status.respond_to?(:active) && status.active)
      tooltip_tag icon_tag(:circle), 'Aktívny', :left, :hover, class: :'muted undecorated'
    else
      tooltip_tag icon_tag(:'circle-blank'), 'Neaktívny', :left, :hover, class: :'muted undecorated'
    end 
  end

  def judge_position(employment)
    options = employment.active ? {} : { class: :muted }

    tooltip_tag employment.judge_position.value, employment.active ? 'Aktívny' : 'Neaktívny', :left, :hover, options
  end

  def judge_at_court_employment(judge, court)
    judge.employments.at_court(court).first
  end

  def judge_at_court_position(judge, court)
    judge_at_court_employment(judge, court).judge_position.value
  end

  def judge_hearings_count_by_employment(employment, options = {})
    content_tag :span, Hearing.during_employment(employment).count, employment.active ? {} : { class: :muted }
  end

  def judge_decrees_count_by_employment(employment, options = {})
    content_tag :span, Decree.during_employment(employment).count, employment.active ? {} : { class: :muted }
  end

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

  def link_to_judge(judge, options = {})
    link_to judge_name(judge, options.delete(:format)), judge_path(judge.id), judge_options(judge, options)
  end

  def links_to_judges(judges, options = {})
    separator = options.delete(:separator) || ', '

    judges.map { |judge| judge.respond_to?(:id) ? link_to_judge(judge, options) : link_to_partial_judge(judge, options) }.join(separator).html_safe
  end

  def link_to_partial_judge(name, options = {})
    tooltip_tag name, 'Sudca nie je uvedený v zozname sudcov.', :bottom, :hover, options
  end

  def links_to_partial_judges(judges, options = {})
    separator = options.delete(:separator) || ', '

    judges.map { |judge| link_to_partial_judge judge, options }.join(separator)
  end

  private

  def judge_options(judge, options)
    options.merge! judge.active ? {} : { class: :muted } if options.delete :adjust_by_activity
    options.merge! judge.active_at(options.delete :adjust_by_activity_at) ? {} : { class: :muted } if options.key? :adjust_by_activity_at
    options
  end
end
