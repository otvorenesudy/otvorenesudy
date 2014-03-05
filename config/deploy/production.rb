require 'whenever/capistrano'

set :domain, "195.146.144.210"

server domain, :app, :web, :db, primary: true

set :deploy_to, "/home/deploy/projects/#{application}_production"
set :user,      "deploy"
set :branch,    "master"
set :rails_env, "production"

role :db, domain, primary: true

# Resque
role :resque_worker,    domain
role :resque_scheduler, domain

set :rvm_ruby_string, "2.1.0@#{application}"

# Whenever
set :whenever_command, "RAILS_ENV=#{rails_env} bundle exec whenever" if rails_env == 'production'
