module SubscriptionsHelper
  def subscription_query(subscription)
    model = subscription.query.model.constantize
    subscription.query.value.map { |name, values| [t("#{model.facets[name].key}.title"), Array.wrap(values) * ', '] }.sort
  end
end
