# See https://developers.google.com/analytics/devguides/collection/analyticsjs/events

module AnalyticsHelper
  def track(category, action = 'click', label = nil)
    if category.is_a?(Hash)
      category, action, label = category.fetch(:in, File.basename(@virtual_path)).titleize.strip, *category.except(:in).first
      action, label = 'navigate', "item:#{label}" if action == :nav
      action = 'click' if action == :as
    end

    { 'on' => 'click,auxclick,contextmenu', 'event-category' => category, 'event-action' => action, 'event-label' => label }.select { |_, v| v.present? }
  end
end
