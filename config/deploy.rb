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

# Resque
set :workers, { :probe_update => 4 }

default_run_options[:pty] = true

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

# Probe (Elasticsearch)
namespace :probe do
  desc "Drop Probe indices"
  task :drop do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake probe:drop"
  end

  desc "Update Probe indices"
  task :update, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake probe:update"
  end

  desc "Enqueue async update of Probe indices"
  task :update_async, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake probe:update:async"
  end

  # TODO: add reload and reload:async
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
  task :move_in_database_yml, roles: :app do
    run "cp #{release_path}/config/database.yml{.example,}"
  end

  desc "Move in configuration files"
  task :move_in_configuration, roles: :app do
    run "cp #{shared_path}/bing.yml #{release_path}/config/bing.yml"
    run "cp #{shared_path}/resque.yml #{release_path}/config/resque.yml"
  end

  after 'deploy',             'deploy:cleanup'
  after 'deploy:update_code', 'rvm:trust_rvmrc'
  after 'deploy:update_code', 'deploy:symlink_shared', 'deploy:move_in_database_yml', 'deploy:move_in_configuration', 'db:create_release'#, 'deploy:migrate'
  after 'deploy:restart',     'resque:restart'

  after 'deploy:update_code' do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} rake assets:precompile"
  end
end
