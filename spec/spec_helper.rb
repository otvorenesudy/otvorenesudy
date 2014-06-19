require 'rubygems'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

`RAILS_ENV=test rake db:reset`

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'capybara/rspec'
require 'capybara/rails'

Capybara.default_selector = :css

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Factory syntax suggar
  config.include FactoryGirl::Syntax::Methods

  # Capybara
  config.include Capybara::DSL

  # Devise (Warden helpers)
  config.include Warden::Test::Helpers

  Warden.test_mode!

  # Probe syntax suggar
  config.include Probe::SpecHelper
end

FIXTURES = "#{::Rails.root}/spec/fixtures"

def load_fixture(path)
  File.open("#{FIXTURES}/#{path}").read
end
