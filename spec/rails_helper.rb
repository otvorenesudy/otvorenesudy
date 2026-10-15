# frozen_string_literal: true

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'capybara/rspec'
require 'webmock/rspec'

Rails.root.glob('spec/support/**/*.rb').each { |file| require file }

# Elasticsearch and the browser driver run locally; everything else on the network is faked.
WebMock.disable_net_connect!(allow_localhost: true)

Sidekiq.testing!(:fake)

RSpec.configure do |config|
  config.fixture_paths = [Rails.root.join('spec/fixtures')]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.include ActiveJob::TestHelper
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Warden::Test::Helpers, type: :system

  config.after(type: :system) { Warden.test_reset! }
  config.before { ActionMailer::Base.deliveries.clear }
end
