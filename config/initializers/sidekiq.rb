require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end

Sidekiq::Web.use Rack::Auth::Basic do |_, password|
  password == Configuration.sidekiq.password
end
