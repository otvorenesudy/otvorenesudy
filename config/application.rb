# frozen_string_literal: true

require_relative 'boot'
require_relative 'version'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'

Bundler.require(*Rails.groups)

module OpenCourts
  class Application < Rails::Application
    config.load_defaults 8.1

    config.autoload_lib(ignore: %w[assets tasks])

    config.time_zone = 'Bratislava'

    config.i18n.available_locales = %i[sk en]
    config.i18n.default_locale = :sk
    config.i18n.load_path += Rails.root.glob('config/locales/**/*.yml')

    # Error pages are rendered by ErrorsController, in the site's layout and the visitor's language.
    config.exceptions_app = routes

    # db/structure.sql: the schema has pgvector columns and HNSW indexes that schema.rb can't express.
    config.active_record.schema_format = :sql

    config.active_job.queue_adapter = :sidekiq

    # The bootstrap gem is here for its SCSS. Its JavaScript, and popper_js's, are global bundles named like the modules
    # in vendor/javascript (bootstrap.js), and Propshaft serves the first file of a name: with the gems inside the app
    # (vendor/bundle, as in CI), that was the gem's.
    config.assets.excluded_paths += %w[bootstrap popper_js].map do |name|
      Pathname(Gem.loaded_specs.fetch(name).full_gem_path).join('assets/javascripts')
    end

    config.generators do |generate|
      generate.test_framework :rspec
      generate.system_tests nil
    end

    config.x.github.organization = 'otvorenesudy'
    config.x.github.repository = 'otvorenesudy'
  end
end
