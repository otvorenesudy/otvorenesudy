require 'resque/server'

Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == ::Configuration.resque.password
end
