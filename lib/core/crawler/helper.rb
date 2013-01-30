module Core
  module Crawler
    module Helper
      def supply(instance, name, attributes, options = {})
        options = supply_defaults.merge options
        map     = {}
        
        attributes.each do |attribute|
          method_name    = parser_method_name(name, attribute)
          map[attribute] = @parser.send(method_name, @document)
          
          return if options[:validate] == :all && map[attribute].blank?
        end
        
        o = yield(*map.values)
        
        unless o.nil?
          map.each do |k, v|
            o.send("#{k}=", v)
          end
          
          @persistor.persist(o)
          
          instance.send("#{name}=", o)
        end
      end
      
      def supply_by_value(instance, name, options = {})
        options = supply_defaults.merge options
        
        supply(instance, name, [:value], options) do |value|
          prefix = instance.class.name.split(/::/).last

          send("#{prefix}_#{name}_by_value_factory").find_or_create(value)
        end
      end
      
      private
      
      def supply_defaults
        {
          validate: :all,
        }
      end
      
      def parser_method_name(name, attribute)
        attribute == :value ? name : "#{name}_#{attribute}"
      end
    end
  end
end
