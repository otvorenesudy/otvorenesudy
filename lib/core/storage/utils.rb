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
        buckets = {}

        src.each { |e, b| stat_data_update(buckets, src, b, e) }

        count, size = stat_attribute(buckets), stat_attribute(buckets)

        count.format = lambda { |s| '%8s'  % s }

        size.format = lambda do |number|
          exponent = number.zero? ? 0 : (Math.log(number) / Math.log(1024)).to_i
          '%13.1f %3s' % ["#{number.to_f / 1024 ** exponent}", [:B, :KiB, :MiB, :GiB, :TiB][exponent]]
        end

        buckets.each do |b, v|
          stat_attribute_update count, v.count
          stat_attribute_update size,  v.size
        end

        if verbose
          puts "--"

          buckets.sort.each do |b, v|
            puts "#{b}  #{count.format.call v.count} #{delta count.format, v.count - count.avg} #{size.format.call v.size} #{delta size.format, v.size - size.avg}"
          end

          puts "--"
          puts "sum #{count.format.call count.sum} #{count.format.call ' '}  #{size.format.call size.sum}"

          [:min, :avg, :max].each do |key|
            puts "#{key}#{[count, size].map { |attribute| " #{attribute.format.call attribute.send(key)} #{delta attribute.format, attribute.send(key) - attribute.avg}" }.join}"
          end

          puts "--"
        else
          puts "#{count.sum} #{size.sum}"
        end
      end

      private

      def construct(defaults)
        Class.new {
          defaults.keys.each { |k| attr_accessor k }

          def initialize(defaults)
            defaults.each { |k, v| self.instance_variable_set "@#{k}", v }
          end
        }.new defaults
      end

      def get(hash, key, options = {})
        hash[key].nil? ? options[:default] : hash[key]
      end

      def delta(format, value)
        "#{format.call value.abs}#{value < 0 ? '-' : (value == 0 ? '=' : '+')}"
      end

      def stat_data
        construct count: 0, size: 0
      end

      def stat_data_update(buckets, storage, bucket, entry)
        path        = File.join storage.root, bucket, entry
        data        = (buckets[bucket] ||= stat_data)
        data.count += 1

        if File.directory? path
          Dir.glob("#{path}/**/*").each { |p| data.size  += File.size(p) }
        else
          data.size += File.size(path)
        end

        data
      end

      def stat_attribute(buckets)
        construct min: nil, max: nil, sum: 0, avg: 0, count: buckets.count, format: nil
      end

      def stat_attribute_update(attribute, value)
        attribute.min  = value if attribute.min.nil? || attribute.min > value
        attribute.max  = value if attribute.max.nil? || attribute.max < value
        attribute.sum += value
        attribute.avg  = (attribute.sum / attribute.count).to_i
        attribute
      end

      def colorize(args)
        super(args).map do |arg|
          arg.gsub!(/^sum(?<line>.+)/i, 'sum'.blue.bold + '\k<line>'.bold)
         #arg.gsub!(/[\w\-\_\?\=\.]+(\/[\w\-\_\?\=\.]+)+/) { |s| s.underline }

          arg.gsub!(/^([a-f\d]{2}\s|\d+)/i)      { |s| s.blue.bold  }
          arg.gsub!(/^(avg|min|max)/i)           { |s| s.blue.bold  }
          arg.gsub!(/\d+(\.\d+)?(\s+.?i?B)?\+/i) { |s| s.green.bold }
          arg.gsub!(/\d+(\.\d+)?(\s+.?i?B)?\-/i) { |s| s.red.bold   }
          arg.gsub!( /0+(\.?0+)?(\s+.?i?B)?\=/i) { |s| s.bold       }
          arg.gsub!(/\s\w*\s*\!$/i)              { |s| s.red.bold   }

          arg
        end
      end
    end
  end
end
