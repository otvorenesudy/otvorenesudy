module JusticeGovSk
  class Storage
    class JudgeCoverLetter < JusticeGovSk::Storage::Data
      include Core::Storage::Binary

      def root
        @root ||= File.join super, 'cover-letters'
      end
    end
  end
end
