# frozen_string_literal: true

# INDICES=courts,judges limits a task to those indices; by default it runs on all of config/probe.yml.
namespace :probe do
  models = lambda do
    indices = ENV['INDICES']&.split(',') || Probe::Configuration.indices

    indices.map { |index| index.singularize.camelize.constantize }
  end

  desc 'Rebuild the indices from the database in new indices, then switch to them'
  task reindex: :environment do
    models.call.each do |model|
      puts "Reindexing #{model.index_name} ..."

      model.reindex
    end
  end

  desc 'Rebuild the indices in the background (Sidekiq, queue probe)'
  task import: :environment do
    models.call.each do |model|
      puts "Enqueuing reindex of #{model.index_name}"

      Probe::ReindexJob.perform_later(model.name)
    end
  end

  desc 'Reindex the records whose document is missing or older than the record (Sidekiq, queue probe)'
  task synchronize: :environment do
    models.call.each do |model|
      puts "Synchronizing #{model.index_name}"

      SynchronizeRepositoryJob.enqueue_for(model)
    end
  end

  desc 'Delete the indices and create them empty'
  task drop: :environment do
    models.call.each do |model|
      puts "Dropping #{model.index_name}"

      model.delete_index
      model.ensure_index
    end
  end
end
