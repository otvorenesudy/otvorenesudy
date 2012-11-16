# encoding: utf-8

namespace :storage do
  task :distribute, [:src, :dst, :verbose] => :environment do |task, args|
    src = args[:src]
    dst = args[:dst]
    
    verbose = args[:verbose] || false 
    
    i = 0
    
    Dir.foreach(src) do |f|
      next if f.start_with? '.' 
      
      b = Storage.bucket f
      s = File.join src, f
      d = File.join dst, b, f
      
      FileUtils.mkpath File.join(dst, b) unless Dir.exists? File.join(dst, b)
      
      puts "#{i} cp #{s} -> #{d}" if verbose
      
      FileUtils.cp s, d
      
      i += 1
      
      puts "-- #{i} --" if i % 1000 == 0
    end
    
    puts "finished"
  end
  
  task :merge, [:src, :dst, :verbose] => :environment do |task, args|
    src = args[:src]
    dst = args[:dst]
    
    verbose = args[:verbose] || false
    
    FileUtils.mkpath dst unless Dir.exists? dst

    i = 0
    
    Dir.foreach(src) do |b|
      next if b.start_with?('.')
      next unless Dir.exists?(File.join src, b)
      
      Dir.foreach(File.join src, b) do |f|
        next if f.start_with? '.'
        
        s = File.join src, b, f
        d = File.join dst, f
        
        puts "#{i} cp #{s} -> #{d}" if verbose
        
        FileUtils.cp s, d
        
        i += 1
        
        puts "-- #{i} --" if i % 1000 == 0
      end
    end
    
    puts "finished"
  end
end
