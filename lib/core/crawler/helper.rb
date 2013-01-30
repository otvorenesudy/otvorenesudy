module Core
  module Crawler
    module Helper
      def supply(instance, name, options = {})
        options = supply_defaults.deep_merge options
        map     = options[:defaults] || {}
        
        options[:parse].each do |attribute|
          method_name    = parser_method_name(name, attribute)
          map[attribute] = @parser.send(method_name, @document)
          
          return if options[:validate] == :all && map[attribute].blank?
        end
        
        if block_given?
          o = yield(*map.values)
        elsif options[:factory]
          o = factory_supply name, map, options[:factory]
        else
          raise "No block given"
        end
        
        unless o.nil?
          map.each do |k, v|
            o.send("#{k}=", v)
          end
          
          @persistor.persist(o)
          
          instance.send("#{name}=", o) if instance.respond_to? "#{name}="
        end
      end
      
      private
      
      def supply_defaults
        {
          validate: :all,
          factory: {
            strategy: :find_or_create
          }
        }
      end
      
      def parser_method_name(name, attribute, options = {})
        method_name = "#{name}_#{attribute}"
        
        return method_name if @parser.respond_to? method_name 
        return name        if @parser.respond_to? name
        return attribute   if @parser.respond_to? attribute
        
        raise "No parser method found for #{name} and #{attribute}"
      end
      
      def factory_supply(name, map, options = {})
        type     = options[:type] || name
        args     = options[:args] || map.keys
        factory  = send("#{type}_by_#{args.join('_and_')}_factory")
        
        factory.send(options[:strategy], *(args.map { |k| map[k] }))
      end
    end
  end
end
