module Core
  class Factory
    class Supplier
      def initialize
        @factories = {}
      end
    
      def get(type, find = nil, options = {})
        key     = "#{type}.#{find || 'new'}".intern
        factory = @factories[key]

        unless factory
          if find
            factory = Factory.new(type) { |*args| type.send(find, *args) }
          else
            factory = Factory.new(type)
          end
          
          factory.verbose = options[:verbose] unless options[:verbose].nil?
          
          @factories[key] = factory
        end

        factory
      end
    end
  end
end
