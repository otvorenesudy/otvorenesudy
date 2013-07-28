# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

use Rack::CanonicalHost, 'otvorenesudy.sk' if Rails.env.production?
run OpenCourts::Application
