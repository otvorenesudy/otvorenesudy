source 'https://rubygems.org'

gem 'rails', '3.2.22.5'
gem 'rake', '< 11'

# database
gem 'pg', '~> 0.11'
gem 'pg_search'

# search
gem 'tire'
gem 'elasticsearch'

# styles
gem 'bootstrap', '~> 4.1.0'
gem 'roadie'

# scripts
gem 'coffee-script'
gem 'execjs'
gem 'jquery-rails', '~> 3.1.5'
gem 'jquery-ui-rails', '~> 3.0.1'
gem 'jquery-tablesorter'
gem 'chart-js-rails', '0.0.7'
gem 'rails-timeago'

# pagination
gem 'kaminari', '~> 0.14.1'
gem 'kaminari-bootstrap', '~> 3.0.1'

# localization
gem 'rails-i18n'

# crawlers
gem 'curb', '>= 0.9.11'
gem 'mechanize', '~> 2.5.1'
gem 'docsplit', '~> 0.6.4'
gem 'json', '1.8.6'
gem 'nokogiri'

# utilities
gem 'squire', '~> 1.2.6'
gem 'colored', '~> 1.2'
gem 'murmurhash3', '>= 0.1.3'
gem 'htmlentities'
gem 'crawler_detect'

# jobs
gem 'sinatra', require: nil
gem 'sidekiq', '< 4.0'
gem 'celluloid', '~> 0.17.2'
gem 'sidekiq-limit_fetch'

# authentication
gem 'devise'
gem 'bcrypt', '~> 3.1.15'

# monitoring
gem 'rollbar', '~> 2.12.0'
gem 'skylight'

# markup
gem 'redcarpet', require: 'redcarpet/compat'
gem 'markdown-rails'

# scheduling
gem 'whenever', '~> 0.9.7'

# hostname
gem 'rack-canonical-host'

# serialization
gem 'active_model_serializers'

# sitemap
gem 'sitemap_generator'

# caching
gem 'dalli', '~> 2.7.6'

# others
gem 'test-unit'
gem 'utf8-cleaner'

group :assets do
  gem 'sass'
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development do
  gem 'bump', git: 'https://github.com/pavolzbell/bump.git'
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-passenger'
  gem 'capistrano-sidekiq'
  gem 'capistrano-git-submodule-strategy', '~> 0.1'
  gem 'bcrypt_pbkdf', '~> 1.1.0'
  gem 'ed25519', '~> 1.2.4'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'fuubar'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'guard-rspec'
  gem 'pry'
end

group :production do
  gem 'unicorn'
end
