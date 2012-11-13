module JusticeGovSk
  module Documents
    module URI
      def self.base
        @path ||= File.join Rails.root, 'public', 'documents'
      end
      
      def self.uri_to_path(downloader, uri)
        decree = Decree.find_by_uri(uri)
        
        ecli_to_path(decree.ecli) unless decree.nil?
      end
      
      def self.ecli_to_path(downloader, ecli)
        path = File.join downloader.cache_root, 'decrees', ''
        path = "#{path}decree-#{ecli.gsub(/\:|\./, '-')}"
        path = "#{path}.#{downloader.cache_file_extension}" unless downloader.cache_file_extension.nil?
        path
      end
    end
  end
end
