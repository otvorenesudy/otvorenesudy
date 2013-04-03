module Core
  module Parser
    module JSON
      include Core::Output
      include Core::Parser

      def parse(content, options = {})
        super { ActiveSupport::JSON.decode(content) }
      end
    end
  end
end
