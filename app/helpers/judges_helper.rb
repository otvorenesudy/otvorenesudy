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

  def judge_hearings_count_by_employment(employment)
    content_tag :span, Hearing.during(employment).count, employment.active ? {} : { class: :muted }
  end
  
  def judge_decrees_count_by_employment(employment)
    content_tag :span, Decree.during(employment).count, employment.active ? {} : { class: :muted }
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
  
  def judge_titles(judge)
    "#{judge.prefix} #{judge.suffix}".strip
  end
  
  def link_to_judge(judge, options = {})
    options.merge! judge.active ? {} : { class: :muted } if options.delete :adjust_by_activity 
    link_to judge_name(judge, options.delete(:format)), judge_path(judge.id), options
  end
end
