module Core
  module Parser
    module JSON
      include Core::Output
      include Core::Parser
      
      def parse(content)
        ActiveSupport::JSON.decode(content)
      end
      
      protected
    
      def find_value(data, key, name = key, options = {}, &block)
        options = defaults.merge options
        
        print "Parsing #{name} ... "
        
        value = data[key] unless data.nil?
        
        if options[:present?]
          if value.nil?
            puts "failed (not present)"
            return
          end
        end
        
        if options[:empty?]
          if value.respond_to?(:empty?) && value.empty?
            puts "failed (empty)"
            return
          end
        end
        
        value = block_given? ? block.call(value) : value
    
        puts options[:verbose] ? "done (#{value})" : "done"
    
        value
      end
      
      private
      
      def defaults
        {
          present?: true,
          empty?:   true,
          verbose:  true
        }
      end
      
      def find_values(data, key, name = key, options = {}, &block)
        find_value(data, key, name, options, &block) || []
      end
    end
  end
end
