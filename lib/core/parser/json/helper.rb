module Core
  module Parser
    module JSON
      module Helper
        include Core::Parser::Helper
        
        private
        
        def find_strategy(name, data, key = name, options = {}, &block)
          data.respond_to?(:'[]') ? data[key] : nil
        end
      end
    end
  end
end
