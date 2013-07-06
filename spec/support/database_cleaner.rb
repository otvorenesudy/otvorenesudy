RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:all) do
    DatabaseCleaner.start

    load "#{Rails.root}/db/seeds.rb"
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end
end
