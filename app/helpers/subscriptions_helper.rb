# frozen_string_literal: true

module SubscriptionsHelper
  # The saved search's facets by their titles, each with its values: [['Súd', 'Okresný súd Košice I'], ...].
  def subscription_query(subscription)
    model = subscription.query.model.constantize

    subscription.query.value.map do |name, values|
      [t("#{model.facets[name].key}.title"), Array.wrap(values).join(', ')]
    end
                .sort
  end
end
