module Core
  module Crawler
    module Helper
      def supply(base, attribute, options = {})
        options = supply_defaults.deep_merge options

        if options[:parser].is_a? Proc
          map = options[:parser].call attribute
        else
          map = parse_instance_attributes attribute, options
        end

        return if map.nil?

        if options[:factory].is_a? Proc
          instance = options[:factory].call(*map.values)
        else
          instance = supply_instance attribute, map, options[:factory]
        end

        # TODO consider merging factory and instance together:
        # supply_instance + set_instance_attributes,
        # it could simplify for example (chair) judge supplying

        return if instance.nil?

        if options[:instance].is_a? Proc
          options[:instance].call instance, map
        else
          set_instance_attributes instance, map, options
        end

        @persistor.persist(instance)

        if options[:association].is_a? Proc
          options[:association].call base, attribute, instance
        else
          set_base_attribute base, attribute, instance, options
        end
      end

      private

      def supply_defaults
        {
          validate: :all,
          parser: {},
          factory: { strategy: :find_or_create },
          instance: {},
          association: :belongs_to
        }
      end

      def parse_instance_attributes(attribute, options = {})
        map = options[:defaults] || {}

        Array.wrap(options[:parse]).each do |k|
          method_name = parser_method_name(attribute, k)
          map[k]      = @parser.send(method_name, @document)

          return if options[:validate] == :all && map[k].blank?
        end

        map
      end

      def parser_method_name(base, attribute, options = {})
        method_name = "#{base}_#{attribute}"

        return method_name if @parser.respond_to? method_name
        return base        if @parser.respond_to? base
        return attribute   if @parser.respond_to? attribute

        raise "No parser method found for #{base} and #{attribute}"
      end

      def supply_instance(base, map, options = {})
        type     = options[:type] || base
        args     = Array.wrap options[:args] || map.keys
        factory  = send("#{type}_by_#{args.join('_and_')}_factory")

        factory.send options[:strategy], *(args.map { |k| map[k] })
      end

      def set_instance_attributes(instance, map, options = {})
        Array.wrap(options[:instance][:attributes] || map.keys).each do |k|
          instance.send("#{k}=", map[k])
        end
      end

      def set_base_attribute(base, attribute, instance, options = {})
        case options[:association]
        when :belongs_to
          begin
            base.send("#{attribute}=", instance)
          rescue
            raise "Unable to associate #{base} with #{instance} through #{attribute}"
          end
        when :has_many
          begin
            attribute = base.class.name.underscore

            instance.send("#{attribute}=", base)
          rescue
            raise "Unable to associate #{instance} with #{base} through #{attribute}"
          end
        else
          raise "Unknown association #{options[:association]}"
        end
      end
    end
  end
end
