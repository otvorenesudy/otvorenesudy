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

options = { at: '07:00am' }

every :day, options do
  rake 'subscriptions:run[daily]'
end

every :week, options do
  rake 'subscriptions:run[weekly]'
end

every :month, options do
  rake 'subscriptions:run[monthly]'
end

every :day, at: '02:00am' do
  rake 'crawl:courts:backup'
  rake 'crawl:courts'
  rake 'crawl:judges'
end

every :day, at: '03:00am' do
  rake 'crawl:hearings:special'
end

every :day, at: '04:00am' do
  rake 'crawl:selection_procedures'
end

every 2.days do
  rake 'work:hearings:civil'
  rake 'work:hearings:criminal'
end

every 3.days do
  rake 'work:decrees'
end
