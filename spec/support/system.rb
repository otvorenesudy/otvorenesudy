# frozen_string_literal: true

# System specs drive the app through the rendered pages: rack_test by default, headless Chrome when a scenario needs
# JavaScript (`js: true`). Chrome resolves only localhost, so third-party scripts (analytics, fonts) never load.
# Selenium Manager fetches the chromedriver matching the installed Chrome, which updates itself; a chromedriver on the
# PATH (Homebrew's) falls behind it and fails to start.
ENV['SE_SKIP_DRIVER_IN_PATH'] ||= 'true'

RSpec.configure do |config|
  config.before(type: :system) do
    driven_by :rack_test
  end

  config.before(type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1000] do |options|
      options.add_argument('--host-resolver-rules=MAP * ~NOTFOUND, EXCLUDE 127.0.0.1, EXCLUDE localhost')
    end
  end
end

Capybara.default_max_wait_time = 5
