module JusticeGovSk
  module Storages
    module Document
      extend Storage
      
      def self.root
        @root ||= File.join super, 'documents'
      end
 
      @binary     = true
      @distribute = true 
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
