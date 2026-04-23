namespace :subscriptions do
  task :run, [:period] => :environment do |_, args|
    period = args[:period]
    Subscription.by_period(period).each { |subscription| NotifySubscriptionJob.perform_async(subscription.id) }
  end
end
