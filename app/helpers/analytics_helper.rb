# See https://developers.google.com/analytics/devguides/collection/analyticsjs/events

module AnalyticsHelper
  def track(category, action = 'click', label = nil)
    if category.is_a?(Hash)
      category, action, label = File.basename(@virtual_path).titleize.strip, *category.first
      action, label = 'navigate', "item:#{label}" if action == :nav
      action = 'click' if action == :as
    end

    # TODO maybe track simple clicks only?
    { 'on' => 'click,auxclick,contextmenu', 'event-category' => category, 'event-action' => action, 'event-label' => label }.select { |_, v| v.present? }
  end
end
