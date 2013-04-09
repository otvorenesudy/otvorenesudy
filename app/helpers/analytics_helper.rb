module AnalyticsHelper
  def track_data(value)
    { :'data-track' => value }
  end

  def track_data_attr(value)
    track_data(value).map { |k, v| "#{k}=\"#{v}\"" }.join(' ').html_safe
  end
end
