# frozen_string_literal: true

# The cron jobs (whenever; Capistrano writes them to the crontab on deploy). Errors in runner jobs go to Sentry through
# Rails.error.

set :output, 'log/cron.log'

every :day, at: '7:00 am' do
  rake 'subscriptions:run[daily]'
end

# Weekly is Monday's: whenever's :week means days 1, 8, 15 and 22, which a week's results don't cover.
every :monday, at: '7:00 am' do
  rake 'subscriptions:run[weekly]'
end

every :month, at: '7:00 am' do
  rake 'subscriptions:run[monthly]'
end

every :day, at: '1:00 am' do
  runner 'Rails.error.record { [Hearing, Decree].each { |model| model.recheck_index; model.consolidate_index } }'
end

every :day, at: '1:30 am' do
  rake '-s sitemap:refresh:no_ping'
end

# Pages and fragments are cached without expiry; a day's changes show the next morning.
every :day, at: '2:00 am' do
  runner 'Rails.error.record { Rails.cache.clear }'
end

every :day, at: '2:30 am' do
  runner 'Rails.error.record { Decree.where(pdf_uri: nil).find_each(&:destroy) }'
end

every :saturday, at: '10:00 am' do
  runner 'Rails.error.record { Decree.find_in_batches { |batch| ' \
         'MarkDecreesWithInvalidPdfUriJob.perform_later(batch.map { |decree| [decree.id, decree.pdf_uri] }) } }'
end
