module JudgesHelper
  def judge_employment(judge, court)
    judge.employments.where(court_id: court).first
  end
  
  def judge_position(judge, court)
    judge_employment(judge, court).judge_position.value
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
  
  def link_to_judge(judge, format = nil)
    link_to judge_name(judge, format), judge_path(judge.id)
  end
end
