# frozen_string_literal: true

namespace :subscriptions do
  task :run, [:period] => :environment do |_, args|
    period = args[:period]
    subscriptions = Subscription.by_period(period).of_confirmed_users

    subscriptions.find_each { |subscription| NotifySubscriptionJob.perform_later(subscription.id) }
  end
end
