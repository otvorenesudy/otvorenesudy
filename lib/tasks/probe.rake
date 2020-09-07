namespace :probe do
  def indices_to_models(indices)
    Hash[indices.map { |index| [index, index.singularize.camelize.constantize] }]
  end

  task prepare: :environment do
    INDICES = ENV['INDICES'] ? ENV['INDICES'].split(',') : Probe::Configuration.indices
  end

  desc 'Import entire index asynchronously (drop and create index from scratch)'
  task import: :environment do
    Rake::Task['probe:prepare'].invoke

    indices_to_models(INDICES).each do |index, model|
      puts "Index import: #{index}"

      Probe::Bulk.async_import(model)
    end
  end

  desc 'Update asynchronously'
  task synchronize: :environment do
    Rake::Task['probe:prepare'].invoke

    indices_to_models(INDICES).each do |index, model|
      puts "Synchronizing index async: #{index}"

      SynchronizeRepositoryJob.enqueue_for(model)
    end
  end

  desc 'Drop entire index'
  task drop: :environment do
    Rake::Task['probe:prepare'].invoke

    indices_to_models(INDICES).each do |index, model|
      puts "Deleting index: #{index}"

      model.delete_index
      model.create_index
    end
  end
end
