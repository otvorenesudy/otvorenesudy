namespace :es do
  INDICES = ENV['INDICES'] ? ENV['INDICES'].split(',') : ['hearings', 'decrees', 'decree_pages']

  # TODO: find out why index increses by multiple update

  task update: :environment do
    INDICES.each do |index|
      puts "* Importing index: #{index}"

      model = index.singularize.camelize.constantize

      model.find_each do |record|
        record.update_index
      end
    end
  end

  task drop: :environment do
    ENV['INDICES'] = INDICES.join(',')

    Rake::Task['tire:index:drop'].invoke
  end

  task reload: :environment do
    Rake::Task['es:drop'].invoke
    Rake::Task['es:update'].invoke
  end
end
