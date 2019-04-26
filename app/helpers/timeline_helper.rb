module TimelineHelper
  def timeline_distance(a, b)
    return 'unknown' if a.nil? || b.nil?

    a, b = [a, b].map { |e| e.date.try :to_time }

    case ((a - b) / (60 * 60 * 24)).abs.round
    when 0..0     then 'less-than-day'
    when 1..7     then 'day-to-week'
    when 8..31    then 'week-to-month'
    when 32..181  then 'month-to-half-year'
    when 182..365 then 'half-year-to-year'
    else
      'more-than-year'
    end
  end
end
