RSpec.configure do |config|
  config.before(:all) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start

    load Rails.root.join('db/seeds.rb')

    EnumerableHelper.reload
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
