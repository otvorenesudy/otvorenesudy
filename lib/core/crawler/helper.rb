# TODO improve API

module Core
  module Crawler
    module Helper
      def supply(base, attribute, options = {})
        options = supply_defaults.deep_merge options
        map     = options[:defaults] || {}
        
        options[:parse].each do |k|
          method_name = parser_method_name(attribute, k)
          map[k]      = @parser.send(method_name, @document)
          
          return if options[:validate] == :all && map[k].blank?
        end
        
        if block_given?
          instance = yield(*map.values)
        else
          instance = factory_supply attribute, map, options[:factory]
        end
        
        unless instance.nil?
          map.each do |k, v|
            instance.send("#{k}=", v)
          end
          
          @persistor.persist(instance)
          
          base.send("#{attribute}=", instance) if instance.respond_to? "#{attribute}="
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
      
      def parser_method_name(base, attribute, options = {})
        method_name = "#{base}_#{attribute}"
        
        return method_name if @parser.respond_to? method_name 
        return base        if @parser.respond_to? base
        return attribute   if @parser.respond_to? attribute
        
        raise "No parser method found for #{base} and #{attribute}"
      end
      
      def factory_supply(base, map, options = {})
        type     = options[:type] || base
        args     = options[:args] || map.keys
        factory  = send("#{type}_by_#{args.join('_and_')}_factory")
        
        factory.send(options[:strategy], *(args.map { |k| map[k] }))
      end
    end
  end
end
