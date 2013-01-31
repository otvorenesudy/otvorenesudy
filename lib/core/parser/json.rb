module Core
  module Parser
    module JSON
      include Core::Output
      include Core::Parser
      
      def parse(content)
        # TODO add clearing
        super do
          ActiveSupport::JSON.decode(content)
        end
      end
    end
  end
end
