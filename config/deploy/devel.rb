server domain, :app, :web, :db, primary: true

set :deploy_to, "/home/deploy/projects/#{application}_devel"
set :user,      "deploy"
set :branch,    "master"
set :rails_env, "production"

set :rvm_ruby_string, "1.9.3@#{application}"
