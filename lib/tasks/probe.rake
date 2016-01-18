namespace :probe do
  def indices_to_models(indices)
    Hash[indices.map { |index| [index, index.singularize.camelize.constantize] }]
  end

  task prepare: :environment do
    INDICES = ENV['INDICES'] ? ENV['INDICES'].split(',') : Probe::Configuration.indices
  end

  desc "Updates the entire index"
  task update: :environment do
    Rake::Task['probe:prepare'].invoke

    indices_to_models(INDICES).each do |index, model|
      Probe::Bulk.update(model.where('updated_at >= ?', 7.days.ago))
    end
  end

  desc "Imports the entire index (drops and creates index from scratch)"
  task :'import' => :environment do
    Rake::Task['probe:prepare'].invoke

    indices_to_models(INDICES).each do |index, model|
      puts "Sync index import: #{index}"

      Probe::Bulk.import(model)
    end
  end

  desc "Imports the entire index asynchronously (drops and creates index from scratch)"
  task :'import:async' => :environment do
    Rake::Task['probe:prepare'].invoke

    indices_to_models(INDICES).each do |index, model|
      puts "Scheduling async index import: #{index}"

      Probe::Bulk.async_import(model)
    end
  end

  desc "Drops the entire index"
  task drop: :environment do
    Rake::Task['probe:prepare'].invoke

    indices_to_models(INDICES).each do |index, model|
      puts "Deleting index: #{index}"

      model.delete_index
    end
  end

  desc 'Update async'
  task update_async: :environment do
    Rake::Task['probe:prepare'].invoke

    indices_to_models(INDICES).each do |index, model|
      puts "Updating index async: #{index}"

      UpdateRepositoryJob.perform_async(model.to_s, 2.days.ago)
    end
  end
end
