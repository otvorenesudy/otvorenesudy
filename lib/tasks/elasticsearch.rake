namespace :es do
  INDICES = ['hearings']
  
  task import: :environment do
    INDICES.each do |index|
      puts "* Importing index: #{index}"

      model = index.singularize.camelize.constantize

      model.find_in_batches(batch_size: 5000) do |group|
        model.index.import group
      end
    end
  end

  task :drop do
    ENV['INDICES'] = INDICES.join(',')
    
    Rake::Task['tire:index:drop'].invoke
  end

  task reload: :environment do
    Rake::Task['es:drop'].invoke
    Rake::Task['es:import'].invoke
  end
end
