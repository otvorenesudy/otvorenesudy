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
      options.add_option('goog:loggingPrefs', { browser: 'ALL' })
    end
  end

  # A failed example in the browser reports what the page's console said, where a script error shows.
  config.after(type: :system, js: true) do |example|
    next unless example.exception

    entries = page.driver.browser.logs.get(:browser).reject { |entry| entry.level == 'INFO' }
    warn "\nBrowser console of \"#{example.full_description}\":\n#{entries.join("\n")}" if entries.any?
  end
end

Capybara.default_max_wait_time = 5
Capybara.enable_aria_label = true

# Where the browser drew an element ('top', 'left', 'width'...), for scenarios about the layout (`js: true`).
module LayoutHelpers
  def bounds(element)
    page.evaluate_script('arguments[0].getBoundingClientRect().toJSON()', element)
  end
end

RSpec.configure do |config|
  config.include LayoutHelpers, type: :system

  # A narrower window (`js: true, width: 390` for a phone). Examples share the browser, so the others get the desktop
  # width back.
  config.before(type: :system, js: true) do |example|
    current_window.resize_to(example.metadata[:width], 1000) if example.metadata[:width]
  end

  config.after(type: :system, js: true) do |example|
    current_window.resize_to(1400, 1000) if example.metadata[:width]
  end
end
