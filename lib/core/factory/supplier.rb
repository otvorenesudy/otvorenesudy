module Core
  class Factory
    class Supplier
      def initialize
        @factories = {}
      end
    
      def get(type, find = nil, options = {})
        key     = "#{type}.#{find || 'new'}"
        factory = @factories[key]
        puts "XXX #{factory.type || nil}"
        unless factory
          puts "CREATING #{key}"
          if find
            find_block = lambda { |*a| type.send(find, *a) }
            factory = Factory.new(type) { |*args| find_block.call(*args) }
          else
            factory = Factory.new(type)
          end
          
          factory.verbose = options[:verbose] unless options[:verbose].nil?
          
          @factories[key] = factory
        end
        puts "GETTING #{key}"
        factory
      end
    end
  end
end
