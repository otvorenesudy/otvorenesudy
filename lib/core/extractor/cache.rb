module Core
  module Extractor
    module Cache
      protected

      include Core::Storage::Cache

      def root
        @root ||= File.join super, 'extracts'
      end
    end
  end
end
