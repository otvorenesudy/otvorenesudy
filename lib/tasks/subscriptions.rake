namespace :subscriptions do
  task :run, [:period] => :environment do |_, args|
    period = args[:period]

    Subscription.by_period(period).each do |subscription|
      sleep 5 # NOTE: simple throttle for notification sending to resolve mailgun errors, not proud of this
      subscription.notify
    end
  end
end
