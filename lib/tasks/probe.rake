namespace :probe do
  def constantize_indices(indices)
    indices.map { |index| index.singularize.camelize.constantize }
  end

  task prepare: :environment do
    INDICES = ENV['INDICES'] ? ENV['INDICES'].split(',') : Probe::Configuration.indices
  end

  desc 'Updates the current index'
  task update: :environment do
    Rake::Task['probe:prepare'].invoke

    constantize_indices(INDICES).each do |model|
      puts "Index update: #{model}"

      Probe::Bulk.update(model)
    end
  end

  desc 'Imports the entire index (drops and creates index from scratch)'
  task :'import' => :environment do
    Rake::Task['probe:prepare'].invoke

    constantize_indices(INDICES).each do |model|
      puts "Sync index import: #{model}"

      Probe::Bulk.import(model)
    end
  end

  desc 'Asynchronious import'
  task :'import:async' => :environment do
    Rake::Task['probe:prepare'].invoke

    constantize_indices(INDICES).each do |model|
      puts "Scheduling async index import: #{model}"

      Probe::Bulk.async_import(model)
    end
  end

  task drop: :environment do
    Rake::Task['probe:prepare'].invoke

    constantize_indices(INDICES).each do |model|
      puts "Deleting index: #{model}"

      model.delete_index
    end
  end
end
