RSpec.configure do |config|

  config.before(:suite) do
  end

  config.before(:all) do
    DatabaseCleaner.clean_with :truncation

    DatabaseCleaner.strategy = :transaction
  end


  config.before(:each) do
    DatabaseCleaner.start

    EnumerableHelper.reload
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
