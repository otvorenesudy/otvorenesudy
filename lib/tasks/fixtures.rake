namespace :fixtures do
  namespace :db do
    desc "Setups small database with production data using Resque workers"
    task setup: :environment do
      Rake::Task['crawl:courts'].invoke
      Rake::Task['crawl:judges'].invoke
      
      begin Rake::Task['crawl:hearings:civil'].invoke    1, 5000 end
      begin Rake::Task['crawl:hearings:criminal'].invoke 1, 5000 end
      begin Rake::Task['crawl:hearings:special'].invoke  1, 5000 end
      
      DecreeForm.all.each do |form|
        begin Rake::Task['crawl:decrees'].invoke form.code, 1, 1000 end
      end
    end
  end
  
  namespace :decrees do
    desc "Extract missing images of decree documents"
    task :extract_images, [:override] => :environment do |_, args|
      include Core::Pluralize
      include Core::Output
      
      args.with_defaults override: false
      
      document_storage = JusticeGovSk::Storage::DecreeDocument.instance
      image_storage    = JusticeGovSk::Storage::DecreeImage.instance
      
      document_storage.batch do |entries, bucket|
        print "Running image extraction for bucket #{bucket}, "
        print "#{pluralize entries.size, 'document'}, "
        puts  "#{args[:override] ? 'overriding' : 'skipping'} already extracted."
        
        n = 0
        
        entries.each do |entry|
          next unless args[:override] || !image_storage.contains?(entry)
         
          options = { output: image_storage.path(entry) }
          
          JusticeGovSk::Extractor::Image.extract document_storage.path(entry), options
          
          n += 1
        end
        
        puts "finished (#{pluralize n, 'document'} extracted)"
      end
    end
  end
end
