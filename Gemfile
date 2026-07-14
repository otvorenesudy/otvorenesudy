ruby '~> 3.3.11'

source 'https://rubygems.org'

gem 'rails', '~> 8.0'
gem 'rake'

# database
gem 'pg', '~> 1.5'
gem 'pg_search'

# search
gem 'elasticsearch', '~> 9.0'

# styles
gem 'bootstrap', '~> 4.1.0'
gem 'dartsass-rails'
gem 'roadie-rails', '~> 3.2'

# assets
gem 'propshaft'
gem 'importmap-rails'

# hotwire
gem 'turbo-rails'
gem 'stimulus-rails'

# pagination
gem 'kaminari', '~> 1.2'

# localization
gem 'rails-i18n'

# utilities
gem 'murmurhash3', '>= 0.1.3'
gem 'htmlentities'
gem 'nokogiri'
gem 'rainbow'

# jobs / queue
gem 'solid_queue'
gem 'mission_control-jobs'

# cache
gem 'solid_cache'

# authentication
gem 'devise', '~> 4.9'
gem 'bcrypt', '~> 3.1'

# monitoring
gem 'sentry-ruby'
gem 'sentry-rails'

# markup
gem 'redcarpet', '~> 3.6'

# scheduling
gem 'whenever', '~> 1.0'

# hostname
gem 'rack-canonical-host'

# serialization
gem 'active_model_serializers', '~> 0.10'

# sitemap
gem 'sitemap_generator'

# app server
gem 'puma', '~> 6'

# bootsnap
gem 'bootsnap', require: false

group :development do
  gem 'bump', git: 'https://github.com/pavolzbell/bump.git'
  gem 'capistrano', '~> 3.19'
  gem 'capistrano-rails', '~> 1.6'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv', '~> 2.2'
  gem 'capistrano-puma', require: false
  gem 'capistrano-git-submodule-strategy', '~> 0.1'
  gem 'bcrypt_pbkdf', '~> 1.1'
  gem 'ed25519', '~> 1.2'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 7'
  gem 'fuubar'
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'capybara', '~> 3.40'
  gem 'selenium-webdriver', '~> 4'
  gem 'guard-rspec'
  gem 'pry-byebug'
  gem 'webmock'
  gem 'vcr'
end

group :test do
  gem 'simplecov', require: false
  gem 'simplecov-cobertura', require: false
end

