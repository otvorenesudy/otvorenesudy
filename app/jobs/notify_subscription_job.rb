class NotifySubscriptionJob < ApplicationJob
  queue_as :default

  def perform(subscription_id)
    Subscription.find(subscription_id).notify
  end
end
