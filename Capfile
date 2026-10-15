# frozen_string_literal: true

require 'capistrano/setup'
require 'capistrano/deploy'

# Git with the data submodule (otvorenesudy-data).
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git
require 'capistrano/scm/git-with-submodules'
install_plugin Capistrano::SCM::Git::WithSubmodules

require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/passenger'

# Sidekiq as the deploy user's systemd service (sidekiq_install installs it once).
require 'capistrano/sidekiq'
install_plugin Capistrano::Sidekiq
install_plugin Capistrano::Sidekiq::Systemd

require 'capistrano/sitemap_generator'
require 'whenever/capistrano'

Dir.glob('lib/capistrano/tasks/*.rake').each { |task| import task }
