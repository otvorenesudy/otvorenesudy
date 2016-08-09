namespace :probe do
  def indices_to_models(indices)
    Hash[indices.map { |index| [index, index.singularize.camelize.constantize] }]
  end

  task prepare: :environment do
    INDICES = ENV['INDICES'] ? ENV['INDICES'].split(',') : Probe::Configuration.indices
  end

  desc 'Imports the entire index asynchronously (drops and creates index from scratch)'
  task :import_async => :environment do
    Rake::Task['probe:prepare'].invoke

    indices_to_models(INDICES).each do |index, model|
      puts "Index async import: #{index}"

      ImportRepositoryJob.perform_async(model.to_s)
    end
  end

  desc 'Update async'
  task synchronize: :environment do
    Rake::Task['probe:prepare'].invoke

    indices_to_models(INDICES).each do |index, model|
      puts "Synchronizing index async: #{index}"

      SynchronizeRepositoryJob.enqueue_for(model)
    end
  end

  desc 'Drops the entire index'
  task drop: :environment do
    Rake::Task['probe:prepare'].invoke

    indices_to_models(INDICES).each do |index, model|
      puts "Deleting index: #{index}"

      model.delete_index
      model.create_index
    end
  end
end
