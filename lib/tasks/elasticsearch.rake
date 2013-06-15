namespace :es do

  # TODO: find out why index increses by multiple update

  task prepare: :environment do
    INDICES = ENV['INDICES'] ? ENV['INDICES'].split(',') : Probe::Configuration.indices
  end

  task update: :environment do
    Rake::Task['es:prepare'].invoke

    INDICES.each do |index|
      puts "* Importing index: #{index}"

      model = index.singularize.camelize.constantize

      model.find_each do |record|
        record.update_index
      end
    end
  end

  task drop: :environment do
    Rake::Task['es:prepare'].invoke

    ENV['INDICES'] = INDICES.join(',')

    Rake::Task['tire:index:drop'].invoke
  end

  task reload: :environment do
    Rake::Task['es:drop'].invoke
    Rake::Task['es:update'].invoke
  end
end
