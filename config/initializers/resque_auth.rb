require 'resque/server'

Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == Resque::Configuration.auth.password
end
