# frozen_string_literal: true

# Redis database 0 is part of the contract with otvorenesudy-api, which pushes UpdateRepositoryJob into it.
redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }

Sidekiq.configure_server { |config| config.redis = redis }
Sidekiq.configure_client { |config| config.redis = redis }
