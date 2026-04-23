class NotifySubscriptionJob
  include Sidekiq::Worker

  sidekiq_options queue: :default

  def perform(subscription_id)
    Subscription.find(subscription_id).notify
  end
end
