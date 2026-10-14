# frozen_string_literal: true

namespace :subscriptions do
  task :run, [:period] => :environment do |_, args|
    period = args[:period]
    Subscription.by_period(period).each { |subscription| NotifySubscriptionJob.perform_later(subscription.id) }
  end
end
