require 'rake'

Rake.application.rake_require 'tasks/probe'
Rake::Task.define_task :environment

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:all) do
    DatabaseCleaner.start

    load "#{Rails.root}/db/seeds.rb"

    Rake::Task['probe:drop']
    Rake::Task['probe:update']
  end

  config.after(:all) do
    DatabaseCleaner.clean

    Rake::Task['probe:drop']
  end

end
