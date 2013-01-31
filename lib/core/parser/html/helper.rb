module Core
  module Parser
    module HTML
      module Helper
        include Core::Parser::Helper
        
        def find_value(name, element, selector = nil, options = {}, &block)
          super { selector.blank? ? element : element.search(selector) }
        end
      end
    end
  end
end
