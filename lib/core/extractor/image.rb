module Core
  module Extractor
    module Image
      include Core::Extractor
      
      def extract(path)
        # TODO implement
      end
      
      def formats
        @formats ||= [:pdf]
      end
    end
  end
end
