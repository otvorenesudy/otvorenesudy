module JusticeGovSk
  class Storage
    class Page < JusticeGovSk::Storage
      include Core::Storage::Textual

      def root
        @root ||= File.join super, 'pages'
      end
    end
  end
end
