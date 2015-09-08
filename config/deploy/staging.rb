set :domain, "195.146.144.210"

server domain, :app, :web, :db, primary: true

set :deploy_to, "/home/deploy/projects/#{application}_staging"
set :user,      "deploy"
set :branch,    "staging"
set :rails_env, "staging"

role :db, domain, primary: true

set :rvm_ruby_string, "2.1.0@#{application}"
