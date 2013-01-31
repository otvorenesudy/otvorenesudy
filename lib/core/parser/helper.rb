module Core
  module Parser
    module Helper
      include Core::Output
      
      def find_value(name, document, pattern, options = {}, &block)
        options = find_defaults.merge options
        
        print "Parsing #{name} ... "
        
        value = yield name, document, pattern, options
        
        if [:presence, :content].include? options[:validate]
          if value.nil?
            puts "failed (not present)"
            return
          end
        end
        
        if options[:validate] == :content
          if value.respond_to?(:empty?) && value.empty?
            puts "failed (empty)"
            return
          end
          
          if value.respond_to?(:text) && value.text.strip.empty?
            puts "failed (content empty)"
            return
          end
        end
        
        value = block_given? ? block.call(value) : value
        
        puts options[:verbose] == :extra ? "done (#{value})" : "done"
        
        value
      end
      
      def find_value(name, document, pattern, options = {}, &block)
        find_value(name, document, pattern, options, &block) || []
      end
      
      private
      
      def find_defaults
        { validate: :content, verbose: :extra }
      end
    end
  end
end
