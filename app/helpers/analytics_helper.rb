# See https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide

module AnalyticsHelper
  def track(category, action, label = nil, options = {})
    category, action, label = *[category, action, label].map { |s| Array.wrap(s).map(&:to_s).join(' - ').downcase }
    data = { :'track-category' => category, :'track-action' => action, :'track-label' => label }
    options.deep_merge data: data.select { |_, v| v.present? }
  end
end
