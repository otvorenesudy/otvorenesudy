module Core
  module Parser
    module HTML
      module Helper
        include Core::Parser::Helper

        private

        def find_strategy(name, element, selector = nil, options = {}, &block)
          selector.blank? ? element : element.search(selector)
        end
      end
    end
  end
end
