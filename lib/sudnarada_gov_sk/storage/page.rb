module SudnaradaGovSk
  class Storage
    class Page < SudnaradaGovSk::Storage
      include Core::Storage::Textual
      
      def root
        @root ||= File.join super, 'pages'
      end
    end
  end
end
