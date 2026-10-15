# frozen_string_literal: true

# Deployed by a maintainer with `bundle exec cap production deploy`, from main.
lock '~> 3.20'

set :application, 'otvorenesudy'
set :repo_url, 'git@github.com:otvorenesudy/otvorenesudy.git'

set :user, 'deploy'
set :ssh_options, { forward_agent: true }

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

# The secrets' key (config/credentials/production.yml.enc is committed); the database logins come from the deploy
# user's ~/.env, which its login shell exports.
set :linked_files, fetch(:linked_files, []).push('config/credentials/production.key')
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'storage', 'backups', 'public/sitemaps'
)

set :keep_releases, 2

set :whenever_identifier, -> { "#{fetch(:application)}-#{fetch(:stage)}" }

set :sitemap_roles, :web

set :sidekiq_config_files, ['sidekiq.yml']
set :sidekiq_service_unit_user, :user

namespace :deploy do
  after 'deploy:publishing', 'deploy:restart'
  after 'finishing', 'deploy:cleanup'

  desc 'Deploy to a new server: create and load the database instead of migrating it'
  task :cold do
    invoke 'deploy:starting'
    invoke 'deploy:started'
    invoke 'deploy:updating'
    invoke 'bundler:install'
    invoke 'deploy:prepare_database'
    invoke 'deploy:compile_assets'
    invoke 'deploy:normalize_assets'
    invoke 'deploy:publishing'
    invoke 'deploy:published'
    invoke 'deploy:finishing'
    invoke 'deploy:finished'
  end

  desc 'Create the database and load db/structure.sql, or migrate an existing one'
  task :prepare_database do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) || fetch(:stage) do
          execute :rake, 'db:prepare'
        end
      end
    end
  end
end
