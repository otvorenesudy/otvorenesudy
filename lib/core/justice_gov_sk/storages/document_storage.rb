module JusticeGovSk
  module Storages
    class DocumentStorage
      include Storage
      
      def initialize
        @binary     = true
        @distribute = true
      end

      def root
        @root ||= File.join super, 'documents'
      end
#
# TODO refactor or rm
#     
#      def ecli_to_path(ecli)
#        path = File.join root, 'decrees', ''
#        path = "#{path}decree-#{ecli.gsub(/\:|\./, '-')}"
#        path = "#{path}.#{file_extension}" unless file_extension.nil?
#        path
#      end
    end
  end
end
