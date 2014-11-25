RSpec.configure do |config|
  config.before(:each) do
    if example.options[:clean_with]
      DatabaseCleaner.strategy = example.options[:clean_with]
    else
      DatabaseCleaner.strategy = :transaction
    end

    DatabaseCleaner.start

    load Rails.root.join('db/seeds.rb')

    EnumerableHelper.reload
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
