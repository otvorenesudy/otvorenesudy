require 'bundler/capistrano'
require 'resque'
require 'rvm/capistrano'
require 'capistrano-resque'
#require 'whenever/capistrano'

set :stages, [:staging, :production]

require 'capistrano/ext/multistage'

set :application,    'opencourts'
set :scm,            :git
set :repository,     'git@github.com:otvorenesudy/otvorenesudy.git'
set :scm_passphrase, ''
set :user,           'deploy'

set :use_sudo, false

set :ssh_options, { forward_agent: true }
set :deploy_via, :remote_cache
set :git_enable_submodules, 1

set :keep_releases, 1

# Whenever
# TODO enable when it does not break deployment
set :whenever_command, "RAILS_ENV=#{rails_env} bundle exec whenever"

default_run_options[:pty] = true

namespace :db do
  desc "Migrate DB"
  task :create, roles: :db do
    run "cd #{current_path}; rake db:create RAILS_ENV=#{rails_env}"
  end

  desc "Migrate DB during release"
  task :create_release, roles: :db do
    run "cd #{release_path}; rake db:create RAILS_ENV=#{rails_env}"
  end

  desc "Setup DB during deployment of release for this environment"
  task :setup_release, roles: :db do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} rake db:setup"
  end

  desc "Setup current DB for this environment"
  task :setup_current, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake db:setup"
  end

  desc "Drop DB for this environment"
  task :drop, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake db:drop"
  end

  desc "Reset DB for this environment"
  task :reset, roles: :db do
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

  desc "Import Probe indices"
  task :import, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake probe:import"
  end

  desc "Enqueue async import of Probe indices"
  task :import_async, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake probe:import:async"
  end

  desc "Update Probe indices"
  task :update, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake probe:update"
  end

  desc "Enqueue async update of Probe indices"
  task :update_async, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake probe:update:async"
  end
end

desc 'Restarts Resque workers'
task :restart_resque do
  run "kill -9 `ps aux | grep resque | grep -v grep | cut -c 10-16`"
  run "cd #{current_path}; RAILS_ENV=#{rails_env} COUNT=4 QUEUE=crawlers rake resque:workers"
  run "cd #{current_path}; RAILS_ENV=#{rails_env} COUNT=4 QUEUE=listers rake resque:workers"
end

# If you are using Passenger mod_rails uncomment this
namespace :deploy do
  task :start do
  end

  task :stop do
  end

  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
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
    run "cp #{shared_path}/configuration.yml #{release_path}/config/configuration.yml"
  end

  after 'deploy',             'deploy:cleanup'
  after 'deploy:update_code', 'rvm:trust_rvmrc'
  after 'deploy:update_code', 'deploy:symlink_shared', 'deploy:move_in_database_yml', 'deploy:move_in_configuration', 'db:create_release', 'deploy:migrate'
  after 'deploy:restart',     'restart_resque'

  after 'deploy:update_code' do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} rake assets:precompile"
  end
end
