namespace :es do
  INDICES = ['hearings']
  
  task :import => :environment do
    INDICES.each do |index|
      puts "* Importing index: #{index}"

      model = eval index.singularize.camelize

      model.index.import model.all
    end
  end

  task :drop do
    ENV['INDICES'] = INDICES.join(',')
    
    Rake::Task['tire:index:drop'].invoke
  end

  task :reload => :environment do
    Rake::Task['es:drop'].invoke
    Rake::Task['es:import'].invoke
  end
end
