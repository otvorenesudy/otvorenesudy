# TODO refactor

module Core
  module Storage
    module Utils
      def self.distribute(src, dst, options = {})
        verbose = options[:verbose] || false 
        
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
          
          puts "#{i}" if !verbose && i % 1000 == 0
        end
        
        puts "finished"
      end
      
      def self.merge(src, dst, options = {})
        verbose = options[:verbose] || false
        
        FileUtils.mkpath dst unless Dir.exists? dst
    
        i = 0
        
        Dir.foreach(src) do |b|
          next if b.start_with?('.') || !Dir.exists?(File.join src, b)
          
          Dir.foreach(File.join src, b) do |f|
            next if f.start_with? '.'
            
            s = File.join src, b, f
            d = File.join dst, f
            
            puts "#{i} cp #{s} -> #{d}" if verbose
    
            FileUtils.cp s, d
            i += 1
            
            puts "#{i}" if !verbose && i % 1000 == 0
          end
        end
        
        puts "finished"
      end

      # TODO add / use options      
      def self.stat(src, options = {})
        buckets = {}
        
        Dir.foreach(src) do |b|
          next if b.start_with?('.') || !Dir.exists?(File.join src, b)
          
          buckets[b] = -2
          
          Dir.foreach(File.join src, b) { buckets[b] += 1 }
        end
        
        min = nil
        max = nil
        sum = 0
        
        buckets.each do |b, c|
          min = c if min.nil? || min > c
          max = c if max.nil? || max < c
          
          sum += c
        end
        
        avg = (sum / buckets.count).to_i
    
        puts "--"
    
        buckets.sort.each do |b, c|
          d = c - avg
          
          puts "#{b}  #{'%8d' % c} #{'%8d' % d.abs}#{d < 0 ? '-' : (d == 0 ? '' : '+')}"
        end
        
        mind, maxd = min - avg, max - avg 
        
        puts "--"
        puts "sum #{'%8d' % sum}"
        puts "min #{'%8d' % min} #{'%8d' % mind.abs}#{mind < 0 ? '-' : (mind == 0 ? '' : '+')}"
        puts "avg #{'%8d' % avg} #{'%8d' % 0}"
        puts "max #{'%8d' % max} #{'%8d' % maxd.abs}#{maxd < 0 ? '-' : (maxd == 0 ? '' : '+')}"
        puts "--"
      end
    end  
  end  
end
