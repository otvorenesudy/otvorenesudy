namespace :probe do

  # TODO: find out why index increses by multiple update

  def constantize_indices(indices)
    indices.map { |index| index.singularize.camelize.constantize }
  end

  task prepare: :environment do
    INDICES = ENV['INDICES'] ? ENV['INDICES'].split(',') : Probe::Configuration.indices
  end

  task update: :environment do
    Rake::Task['probe:prepare'].invoke

    constantize_indices(INDICES).each do |model|
      puts "Sync index update: #{model}"

      Probe::Updater.update(model)
    end
  end

  task :'update:async' => :environment do
    Rake::Task['probe:prepare'].invoke

    constantize_indices(INDICES).each do |model|
      puts "Scheduling async index update: #{model}"

      Probe::Updater.async_update(model)
    end
  end

  task drop: :environment do
    Rake::Task['probe:prepare'].invoke

    ENV['INDICES'] = constantize_indices(INDICES).map { |model| model.index_name }.join(',')

    Rake::Task['tire:index:drop'].invoke
  end
end
