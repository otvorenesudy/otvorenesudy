require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |_, password|
  password == Configuration.sidekiq.password
end
