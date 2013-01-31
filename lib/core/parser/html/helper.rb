module Core
  module Parser
    module HTML
      module Helper
        include Core::Parser::Helper
        
        def find_value(name, element, selector = nil, options = {}, &block)
          super do
            value = selector.blank? ? element : element.search(selector)
            
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
                
              if value.respond_to?(:text) && value.text.strip.empty?
                puts "failed (content empty)"
                return
              end
            end
          end
        end
      end
    end
  end
end
