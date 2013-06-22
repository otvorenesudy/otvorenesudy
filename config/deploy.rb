require 'bundler/capistrano'
require 'resque'
require 'rvm/capistrano'
require "capistrano-resque"
#require "whenever/capistrano"

set :stages,        [:staging, :production]
require 'capistrano/ext/multistage'

set :application,    "opencourts"
set :scm,            :git
set :repository,     "git@github.com:otvorenesudy/otvorenesudy-dev.git"
set :scm_passphrase, ""
set :user,           "deploy"

set :use_sudo, false

set :ssh_options,           { :forward_agent => true }
set :deploy_via,            :remote_cache
set :git_enable_submodules, 1

# Whenever
#set :whenever_command, "RAILS_ENV=#{rails_env} bundle exec whenever"

default_run_options[:pty] = true

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :db do

  desc "Migrate Production Database"
  task :create, roles: :db do
    run "cd #{current_path}; rake db:create RAILS_ENV=#{rails_env}"
  end

  desc "Migrate Production Database during release"
  task :create_release, roles: :db do
    run "cd #{release_path}; rake db:create RAILS_ENV=#{rails_env}"
  end

  desc "Setup db during deployment of release for this environment"
  task :setup_release, :roles => :db do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} rake db:setup"
  end

  desc "Setup current db for this environment"
  task :setup_current, :roles => :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake db:setup"
  end

  desc "Drop database for this environment"
  task :drop, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake db:drop"
  end

  desc "Reset database for this environment"
  task :reset, :roles => :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake db:reset"
  end
end

# Rvm
namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end

# Elasticsearch
namespace :es do
  desc "Drop elasticsearch indices"
  task :drop do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake es:drop"
  end

  desc "Update elasticsearch indices"
  task :update, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake es:update"
  end
end

# If you are using Passenger mod_rails uncomment this
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Symlink shared"
  task :symlink_shared, roles: :app do
    run "ln -nfs #{shared_path} #{release_path}/shared"
    run "ln -nfs #{shared_path}/storage #{release_path}"
  end

  desc "Move in database.yml for this environment"
  task :move_in_database_yml, :roles => :app do
    # TODO: use shared configuration
    #run "cp #{deploy_to}/shared/config/database.yml #{current_path}/config/"
    run "cp #{release_path}/config/database.yml{.example,}"
  end

  after 'deploy',             'deploy:cleanup'
  after 'deploy:update_code', 'rvm:trust_rvmrc'
  after 'deploy:update_code', 'deploy:symlink_shared', 'deploy:move_in_database_yml', 'db:create_release'#, 'deploy:migrate'

  after 'deploy:update_code' do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} rake assets:precompile"
  end
end
