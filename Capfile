require 'capistrano/deploy'
require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/passenger'
require 'capistrano/sidekiq'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/git-submodule-strategy'
require 'capistrano/sitemap_generator'
require 'whenever/capistrano'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
