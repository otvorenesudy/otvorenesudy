# frozen_string_literal: true

source 'https://rubygems.org'

ruby file: '.ruby-version'

gem 'rails', '~> 8.1.4'

# database
gem 'neighbor', '~> 1.2'
gem 'pg', '~> 1.7'

# search
gem 'elasticsearch', '~> 9.5'

# server
gem 'bootsnap', require: false
gem 'puma', '>= 7.0'

# assets
gem 'bootstrap', '~> 5.3'
gem 'dartsass-rails'
gem 'importmap-rails'
gem 'propshaft'
gem 'stimulus-rails'
gem 'turbo-rails'

# views
gem 'htmlentities'
gem 'kaminari', '~> 1.2'
gem 'rails-i18n', '~> 8.1'
gem 'redcarpet', '~> 3.6'

# mail
gem 'roadie-rails', '~> 3.4'

# jobs
gem 'sidekiq', '~> 8.1'

# authentication
gem 'devise', '~> 5.0'

# serialization
gem 'active_model_serializers', '~> 0.10.16'

# data
gem 'csv'

# caching
gem 'dalli'

# monitoring
gem 'sentry-rails', '~> 7.1'
gem 'sentry-ruby', '~> 7.1'
gem 'sentry-sidekiq', '~> 7.1'
gem 'skylight', '~> 7.1'

# scheduling
gem 'whenever', '~> 1.1', require: false

# sitemap
gem 'sitemap_generator', '~> 7.1'

# requests with invalid UTF-8
gem 'utf8-cleaner', '~> 2.0'

group :development, :test do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'debug', require: 'debug/prelude'
  gem 'dotenv-rails', '~> 3.2'
  gem 'factory_bot_rails', '~> 6.5'
  gem 'rspec-rails', '~> 8.0'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
end

group :development do
  gem 'bump', git: 'https://github.com/pavolzbell/bump.git', require: false
  gem 'capistrano', '~> 3.20', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-git-with-submodules', '~> 2.0', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'letter_opener_web', '~> 3.0'
  gem 'web-console'
end

group :test do
  gem 'capybara', '~> 3.40'
  gem 'selenium-webdriver', '~> 4.51'
  # undercover 0.8 reads SimpleCov 0.x results; move to SimpleCov 1.x with undercover's next release.
  gem 'simplecov', '~> 0.22', require: false
  gem 'undercover', '~> 0.8.5', require: false
  gem 'webmock', '~> 3.32'
end
