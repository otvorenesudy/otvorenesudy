module JusticeGovSk
  class Storage
    class Image < JusticeGovSk::Storage
      include Core::Storage::Binary
      
      def root
        @root ||= File.join super, 'images'
      end
    end
  end
end
