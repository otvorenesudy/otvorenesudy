namespace :subscriptions do
  task :run, [:period] => :environment do |_, args|
    period = args[:period]

    Subscription.by_period(period).each do |subscription|
      subscription.notify
    end
  end
end
