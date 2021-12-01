set :domain, 'otvorenesudy.sk'

server fetch(:domain), user: 'deploy', roles: %w{app db web}

set :stage,    :staging
set :branch,   'master'
set :app_path, "#{fetch(:application)}-#{fetch(:stage)}"
set :rails_env, :staging
set :deploy_to, "/home/deploy/projects/#{fetch(:app_path)}"
