# frozen_string_literal: true

module TimelineHelper
  # The days between two events, as the class that spaces them on the timeline.
  DISTANCES = {
    0..0 => 'less-than-day',
    1..7 => 'day-to-week',
    8..31 => 'week-to-month',
    32..181 => 'month-to-half-year',
    182..365 => 'half-year-to-year'
  }.freeze

  def timeline_distance(previous, event)
    times = [previous, event].map { |item| item&.date&.to_time }

    return 'unknown' if times.any?(&:nil?)

    days = ((times.first - times.last) / 1.day).abs.round

    DISTANCES.find { |range, _| range.cover?(days) }&.last || 'more-than-year'
  end
end
