# encoding: utf-8

namespace :storage do
  task :distribute, [:src, :dst, :verbose] => :environment do |_, args|
    args.with_defaults verbose: false
    Core::Storage::Utils.distribute args[:src], args[:dst], args
  end
  
  task :merge, [:src, :dst, :verbose] => :environment do |_, args|
    args.with_defaults verbose: false
    Core::Storage::Utils.merge args[:src], args[:dst], args
  end
  
  task :stat, [:src, :verbose] => :environment do |_, args|
    Core::Storage::Utils.stat args[:src], args
  end
  
  namespace :validate do
    task :documents, [:src, :verbose] => :environment do |_, args|
      Core::Storage::Utils.validate args[:src], args do |file|
        (File.open(file, 'r') { |f| f.read 32 } =~ /\%PDF-\d+\.\d+.*/) == 0
      end
    end
    
    task :pages, [:src, :verbose] => :environment do |_, args|
      Core::Storage::Utils.validate args[:src], args do |file|
         buffer = File.open(file, 'r') { |f| f.read }
        (buffer =~ /\<h1\>Detail\s(pojednávania|súdneho\srozhodnutia)\<\/h1\>/i) != nil
      end
    end
  end
end
