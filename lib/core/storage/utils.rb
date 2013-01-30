module Core
  module Storage
    module Utils
      extend Core::Output
      extend self
      
      def build(root, *flags)
        Class.new {
          include Core::Storage
          include Core::Storage::Distributed if flags.include? :distributed
          include Core::Storage::Textual     if flags.include? :textual
          
          def initialize(root)
            @root = root
          end
        }.new(root)
      end
      
      def distribute(src, dst, options = {})
        verbose = get options, :verbose, default: false
        batch   = get options, :batch,   default: 1000
        
        src = build src
        dst = build dst, :distributed
        
        i = 0
        
        src.each do |e|
          b = dst.bucket(e)
          s = File.join src.root, e
          d = File.join dst.root, b, e
          
          FileUtils.mkpath File.join(dst.root, b)
          
          puts "#{i} cp #{s} -> #{d}" if verbose
          
          FileUtils.cp s, d
          i += 1
          
          puts "#{i}" if !verbose && batch && i % batch == 0
        end
        
        puts "finished" if verbose
      end
      
      def merge(src, dst, options = {})
        verbose = get options, :verbose, default: false
        batch   = get options, :batch,   default: 1000

        src = build src, :distributed
        dst = build dst
        
        FileUtils.mkpath dst.root
        
        i = 0
        
        src.each do |e, b|
          s = File.join src.root, b, e
          d = File.join dst.root, e
          
          puts "#{i} cp #{s} -> #{d}" if verbose
          
          FileUtils.cp s, d
          i += 1
          
          puts "#{i}" if !verbose && batch && i % batch == 0
        end
        
        puts "finished" if verbose
      end
      
      def validate(src, options = {})
        verbose = get options, :verbose, default: false
        batch   = get options, :batch,   default: 1000
        
        src = build src, :distributed
        dst = build "#{src.root}-#{options[:invalid] || :invalid}"
        
        i = 0
        
        src.each do |e, b|
          s = File.join src.root, b, e
          
          i += 1
          
          puts "#{i} #{s}" if verbose
          
          unless yield s
            d = File.join dst.root, b, e
            
            puts "#{i} mv #{s} -> #{d} invalid !"
            
            FileUtils.mkpath(File.dirname d)
            FileUtils.mv s, d
          end
          
          puts "#{i}" if !verbose && batch && i % batch == 0
        end
        
        puts "finished" if verbose
      end

      def stat(src, options = {})
        verbose = get options, :verbose, default: true
        
        src     = build src, :distributed
        buckets = Hash.new 0
        
        src.each { |_, b| buckets[b] += 1 }
        
        min, max, sum = nil, nil, 0
        
        buckets.each do |b, c|
          min  = c if min.nil? || min > c
          max  = c if max.nil? || max < c
          sum += c
        end
        
        avg = (sum / buckets.count).to_i
        
        if verbose
          puts "--"
          
          buckets.sort.each do |b, c|
            puts "#{b}  #{'%8d' % c} #{delta c - avg}"
          end
          
          puts "--"
          puts "sum #{'%8d' % sum}"
          puts "min #{'%8d' % min} #{delta min - avg}"
          puts "avg #{'%8d' % avg} #{delta 0}"
          puts "max #{'%8d' % max} #{delta max - avg}"
          puts "--"
        else
          puts sum
        end
      end
      
      private
      
      def get(hash, key, options = {})
        hash[key].nil? ? options[:default] : hash[key]
      end
      
      def delta(d)
        "#{'%8d' % d.abs}#{d < 0 ? '-' : (d == 0 ? '=' : '+')}"
      end
      
      def colorize(args)
        super(args).map do |arg|
          arg.gsub!(/^sum(?<space>\s+)(?<sum>\d+)/i, 'sum'.blue.bold + '\k<space>' + '\k<sum>'.bold)
         #arg.gsub!(/[\w\-\_\?\=\.]+(\/[\w\-\_\?\=\.]+)+/) { |s| s.underline }
          
          arg.gsub!(/^([a-f\d]{2}\s|\d+)/i) { |s| s.blue.bold  }
          arg.gsub!(/^(avg|min|max)/i)      { |s| s.blue.bold  }
          arg.gsub!(/\d+\+$/i)              { |s| s.green.bold }
          arg.gsub!(/\d+\-$/i)              { |s| s.red.bold   }
          arg.gsub!(/0\=$/i)                { |s| s.bold       }
          arg.gsub!(/\s\w*\s*\!$/i)         { |s| s.red.bold   }
          
          arg          
        end
      end
    end  
  end  
end
