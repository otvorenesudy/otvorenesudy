module Core
  module Parser
    module Helper
      def find_value(name, document, pattern, options = {}, &block)
        options = find_defaults.merge options
       
        print "Parsing #{name} ... "
        
        value = yield name, document, pattern, options
        value = block_given? ? block.call(value) : value
    
        puts options[:verbose] ? "done (#{value})" : "done"
    
        value
      end
      
      def find_value(name, document, pattern, options = {}, &block)
        find_value(name, document, pattern, options, &block) || []
      end
      
      private
      
      def find_defaults
        {
          present?: true,
          empty?:   true,
          verbose:  true
        }
      end
    end
  end
end
