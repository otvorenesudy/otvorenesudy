module Core
  module Parser
    module Helper
      include Core::Output
      
      def find_value(name, document, pattern, options = {}, &block)
        options = find_defaults.merge options
        
        print "Parsing #{name} ... "
        
        value = find_strategy name, document, pattern, options
        
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
        
        value = normalize_spaces(value) if options[:normalize]
        value = block_given? ? block.call(value) : value
        
        puts options[:verbose] ? "done (#{value})" : "done"
        
        value
      end
      
      def find_values(name, document, pattern, options = {}, &block)
        find_value(name, document, pattern, options, &block) || []
      end
      
      def normalize_spaces(value)
        value.gsub(/[[:space:]]/, ' ')
      end
      
      private
      
      def find_defaults
        { normalize: true, validate: :content, verbose: true }
      end
    end
  end
end
