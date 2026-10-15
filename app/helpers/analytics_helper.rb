# frozen_string_literal: true

# Data attributes of a tracked event (data-track-category, -action, -label), each part's words joined and lowercased.
module AnalyticsHelper
  def track(category, action, label = nil, options = {})
    category, action, label = [category, action, label].map { |part| Array.wrap(part).join(' - ').downcase }
    data = { 'track-category': category, 'track-action': action, 'track-label': label }

    options.deep_merge(data: data.compact_blank)
  end
end
