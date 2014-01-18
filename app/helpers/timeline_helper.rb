module TimelineHelper
  def timeline_distance(a, b)
    a, b = timeline_date(a), timeline_date(b)

    return :unknown if a.nil? || b.nil?

    case ((a - b) / (60 * 60 * 24)).abs.round
    when 0..0     then :'now'
    when 1..7     then :'day-to-week'
    when 8..31    then :'week-to-month'
    when 32..181  then :'month-to-half-year'
    when 182..365 then :'half-year-to-year'
    else :'year-and-more'
    end
  end

  private

  def timeline_date(event)
    event.date ? event.date.to_time : nil
  end
end
