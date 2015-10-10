# config valid only for current version of Capistrano
lock '3.4.0'

set :user, 'deploy'

# Repository
set :application, 'opencourts'
set :scm,         :git
set :repo_url,    'git@github.com:otvorenesudy/otvorenesudy.git'
set :git_strategy, Capistrano::Git::SubmoduleStrategy

# RVM
set :rvm_type,         :user
set :rvm_ruby_version, '2.2.2'

# Links
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/configuration.yml')
set :linked_dirs,  fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'storage')

# Whenever
set :whenever_identifier, ->{ "#{fetch(:application)}-#{fetch(:stage)}" }

set :keep_releases, 1
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :ssh_options, { forward_agent: true }
set :use_sudo, false

namespace :workers do
  desc 'Start workers'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          log = 'log/sidekiq.log'

          # execute :bundle, 'exec sidekiq -c  2 -q limited-decree-listers  -d -P tmp/pids/sidekiq.pid.1', '-L', log
          execute :bundle, 'exec sidekiq -c  2 -q decree-listers          -d -P tmp/pids/sidekiq.pid.2', '-L', log
          execute :bundle, 'exec sidekiq -c 10 -q decree-crawlers         -d -P tmp/pids/sidekiq.pid.3', '-L', log
          execute :bundle, 'exec sidekiq -c  5 -q hearing-listers         -d -P tmp/pids/sidekiq.pid.4', '-L', log
          execute :bundle, 'exec sidekiq -c  5 -q hearing-crawlers        -d -P tmp/pids/sidekiq.pid.5', '-L', log
        end
      end
    end
  end

  desc 'Stop workers'
  task :stop do
    on roles(:app) do
      within current_path do
        (1..5).each do |n|
          pid = "tmp/pids/sidekiq.pid.#{n}"

          execute :bundle, 'exec sidekiqctl stop', pid, 10
        end
      end
    end
  end
end

namespace :deploy do
  after 'deploy:publishing', 'deploy:restart'
  after 'finishing', 'deploy:cleanup'

  desc 'Deploy app for first time'
  task :cold do
    invoke 'deploy:starting'
    invoke 'deploy:started'
    invoke 'deploy:updating'
    invoke 'bundler:install'
    invoke 'deploy:setup_database' # This replaces deploy:migrations
    invoke 'deploy:compile_assets'
    invoke 'deploy:normalize_assets'
    invoke 'deploy:publishing'
    invoke 'deploy:published'
    invoke 'deploy:finishing'
    invoke 'deploy:finished'
  end

  desc 'Setup database'
  task :setup_database do
    on roles(:db) do
      within release_path do
        with rails_env: (fetch(:rails_env) || fetch(:stage)) do
          execute :rake, 'db:create:all'
          execute :rake, 'db:migrate'
        end
      end
    end
  end

  task :restart do
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end
end

# TODO: Probe
