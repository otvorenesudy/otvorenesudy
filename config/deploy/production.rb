set :domain, 'otvorenesudy1.server.wbsprt.com'

server fetch(:domain), user: 'deploy', roles: %w[app db web]

set :stage, :production
set :branch, 'main'
set :app_path, "#{fetch(:application)}-#{fetch(:stage)}"
set :rails_env, :production
set :deploy_to, "/home/deploy/projects/#{fetch(:app_path)}"
