module Core
  module Parser
    module JSON
      module Helper
        include Core::Parser::Helper
        
        def find_value(name, data, key = name, options = {}, &block)
          super do
            value = data.respond_to?(:'[]') ? data[key] : nil 
            
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
            
            value
          end
        end
      end
    end
  end
end
