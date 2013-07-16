module AnalyticsHelper
  def track_data(value)
    { :'data-track' => value }
  end
end
