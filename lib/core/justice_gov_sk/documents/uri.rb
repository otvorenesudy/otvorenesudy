module JusticeGovSk
  module Documents
    module URI
      def self.base
        @path ||= File.join Rails.root, 'public', 'documents'
      end
      
      def self.uri_to_path(downloader, uri)
        decree = Decree.find_by_uri(uri)
        
        unless decree.nil?
          path = File.join downloader.cache_root, 'decrees', ''
          path = "#{path}#{decree.ecli.gsub(/\:\./, '')}"
          path = "#{path}.#{downloader.cache_extension}" unless downloader.cache_extension.nil?
          path
        end
      end
      
      def self.uri_to_path_lambda
        @uri_to_path_lambda ||= lambda { |downloader, uri| uri_to_path(downloader, uri) }
      end
    end
  end
end
