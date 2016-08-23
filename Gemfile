source 'https://rubygems.org'

gem 'rails', '3.2.22'

# database
gem 'pg'
gem 'pg_search'

# search
gem 'tire'
gem 'elasticsearch'

# styles
gem 'bootstrap', '~> 4.0.0.alpha3.1'
gem 'rails-assets-tether', '~> 1.1.0'
gem 'font-ionicons-rails', '~> 2.0.1.3'
gem 'roadie'

# scripts
gem 'coffee-script'
gem 'execjs'
gem 'jquery-rails', '~> 2.2.1'
gem 'jquery-ui-rails', '~> 3.0.1'
gem 'jquery-tablesorter'
gem 'chart-js-rails'
gem 'inflection-js-rails'
gem 'gmaps4rails', '~> 1.5.6'
gem 'rails-timeago'

# pagination
gem 'kaminari', '~> 0.14.1'
gem 'kaminari-bootstrap', '~> 3.0.1'

# localization
gem 'rails-i18n'

# crawlers
gem 'curb', '>= 0.8.3'
gem 'mechanize', '~> 2.5.1'
gem 'docsplit', '~> 0.6.4'
gem 'json', '1.8.2'
gem 'nokogiri'

# utilities
gem 'squire', '~> 1.2.6'
gem 'colored', '~> 1.2'
gem 'murmurhash3', '>= 0.1.3'
gem 'htmlentities'

# jobs
gem 'sinatra', require: nil
gem 'sidekiq', github: 'mperham/sidekiq'
gem 'celluloid', '~> 0.17.2'
gem 'sidekiq-limit_fetch'

# authentification
gem 'devise'

# monitoring
gem 'rollbar', '~> 2.2.1'
gem 'garelic'
gem 'newrelic_rpm'

# markup
gem 'redcarpet', require: 'redcarpet/compat'
gem 'markdown-rails'

# scheduling
gem 'whenever', github: 'elhu/whenever', branch: 'ruby-2.3-compat' # Remove after merging this: https://github.com/javan/whenever/pull/603

# hostname
gem 'rack-canonical-host'

# serialization
gem 'active_model_serializers'

group :assets do
  gem 'sass', '~> 3.4.18'
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  # deployment
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-passenger'
  gem 'capistrano-sidekiq'
  gem 'capistrano-git-submodule-strategy', '~> 0.1'

  # other
  gem 'bump', github: 'pavolzbell/bump'
end

group :development, :test do
  gem 'rspec-rails',      '~> 2.0'
  gem 'fuubar'
  gem 'database_cleaner', '~> 0.9.1'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'guard-rspec'

  # dev environment
  gem 'dotenv-rails'
end

group :production do
  gem 'unicorn'
end

gem 'test-unit', '~> 3.0'
