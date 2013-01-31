module Core
  module Parser
    module JSON
      module Helper
        include Core::Parser::Helper
        
        def find_value(name, data, key = name, options = {}, &block)
          super { data.respond_to?(:'[]') ? data[key] : nil } 
        end
      end
    end
  end
end
