# See https://developers.google.com/analytics/devguides/collection/analyticsjs/events

module AnalyticsHelper
  def track(category, action, label = nil)
    { 'on' => 'click,auxclick,contextmenu', 'event-category' => category, 'event-action' => action, 'event-label' => label }.select { |_, v| v.present? }
  end
end
