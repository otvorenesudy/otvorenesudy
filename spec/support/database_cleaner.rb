RSpec.configure do |config|

  config.before(:suite) do
  end

  config.before(:each) do
    DatabaseCleaner.start

    DatabaseCleaner.clean_with(:truncation)
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
