# frozen_string_literal: true

# Specs tagged :error_pages see what visitors see when something fails: the error page (ErrorsController through
# config.exceptions_app) instead of the exception raised into the spec.
RSpec.configure do |config|
  config.around(:each, :error_pages) do |example|
    env = Rails.application.env_config
    original = env.slice('action_dispatch.show_exceptions', 'action_dispatch.show_detailed_exceptions')

    env['action_dispatch.show_exceptions'] = :all
    env['action_dispatch.show_detailed_exceptions'] = false

    example.run
  ensure
    env.merge!(original)
  end
end
