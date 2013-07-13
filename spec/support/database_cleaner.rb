RSpec.configure do |config|

  config.before(:suite) do
  end

  config.before(:all) do
    DatabaseCleaner.clean_with :truncation

    DatabaseCleaner.strategy = :transaction
  end


  config.before(:each) do
    DatabaseCleaner.start

    # Dirty reload for enumerable Period
    Object.constants.map {|c| c.to_s.constantize }.each do |c| 
      if c.respond_to?(:included_modules) && c.included_modules.include?(Resource::Enumerable)
        Object.send(:remove_const, c.to_s)
        load "#{c.to_s.singularize.underscore}.rb"
      end
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
