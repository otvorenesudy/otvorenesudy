# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
#
# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
#
# Learn more: http://github.com/javan/whenever

set :output, 'log/cron.log'

every :day, at: '07:00am' do
  rake 'subscriptions:run[daily]'
end

every :week, at: '07:00am' do
  rake 'subscriptions:run[weekly]'
end

every :month, at: '07:00am' do
  rake 'subscriptions:run[monthly]'
end

# TODO: turn off for now and refactor in API repo
#every :day, at: '04:00am' do
#  rake 'crawl:selection_procedures'
#end

every :day, at: '6am' do
  rake '-s sitemap:refresh'
end

every :day, at: '6am' do
  runner 'ExceptionHandler.run { Rails.cache.clear }'
end

every :day, at: '6am' do
  runner 'ExceptionHandler.run { Decree.where(pdf_uri: nil).find_each(&:destroy) }'
end

every :day, at: '1am' do
  runner 'ExceptionHandler.run { Hearing.recheck_index }'
end

every :day, at: '1am' do
  runner 'ExceptionHandler.run { Decree.recheck_index }'
end

every :saturday, at: '10am' do
  runner 'ExceptionHandler.run { Decree.find_in_batches { |batch| MarkDecreesWithInvalidPdfUriJob.perform_async(batch.map { |d| [d.id, d.pdf_uri] }) } }'
end
