# encoding: utf-8

namespace :storage do
  task :distribute, [:src, :dst, :verbose] => :environment do |_, args|
    args.with_defaults verbose: false
    Core::Storage::Util.distribute args[:src], args[:dst], args[:verbose]
  end
  
  task :merge, [:src, :dst, :verbose] => :environment do |_, args|
    args.with_defaults verbose: false
    Core::Storage::Util.merge args[:src], args[:dst], args[:verbose]
  end
  
  task :stat, [:src] => :environment do |_, args|
    Core::Storage::Util.stat args[:src]
  end

  # TODO refactor
  namespace :check do 
    task :documents, [:dir, :verbose] => :environment do |_, args|
      dir     = args[:dir]
      err     = "#{dir}-corrupted"
      verbose = args[:verbose] || false
      
      i = 0
      
      Dir.foreach(dir) do |b|
        next if b.start_with?('.') || !Dir.exists?(File.join dir, b)
            
        Dir.foreach(File.join dir, b) do |f|
          next if f.start_with? '.'
          
          s = File.join dir, b, f
      
          puts "#{i} #{s}" if verbose
        
          buffer = File.open(s, 'r') { |file| file.read 32 }
          
          unless (buffer =~ /\%PDF-\d+\.\d+.*/) == 0
            d = File.join err, b, f
            
            puts "#{i} mv #{s} -> #{d}"
            
            FileUtils.mkpath(File.dirname d)
            FileUtils.mv s, d
          end
          
          i += 1
          
          puts "#{i}" if !verbose && i % 1000 == 0
        end
      end
      
      puts "finished"
    end
    
    task :pages, [:dir, :verbose] => :environment do |_, args|
      dir     = args[:dir]
      err     = "#{dir}-corrupted"
      verbose = args[:verbose] || false
      
      i = 0

      Dir.foreach(dir) do |b|
        next if b.start_with?('.') || !Dir.exists?(File.join dir, b)
            
        Dir.foreach(File.join dir, b) do |f|
          next if f.start_with? '.'
          
          s = File.join dir, b, f
      
          puts "#{i} #{s}" if verbose
        
          buffer = File.open(s, 'r') { |file| file.read }
          
          if (buffer =~ /\<h1\>Detail\s(pojednávania|súdneho\srozhodnutia)\<\/h1\>/i).nil?
            d = File.join err, b, f
            
            puts "#{i} mv #{s} -> #{d}"
            
            FileUtils.mkpath(File.dirname d)
            FileUtils.mv s, d
          end
          
          i += 1
          
          puts "#{i}" if !verbose && i % 1000 == 0
        end
      end
      
      puts "finished"
    end
  end
end
