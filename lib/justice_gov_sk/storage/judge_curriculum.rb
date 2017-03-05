# TODO rm - unused?
module JusticeGovSk
  class Storage
    class JudgeCurriculum < JusticeGovSk::Storage::Data
      include Core::Storage::Binary

      def root
        @root ||= File.join super, 'curriculums'
      end
    end
  end
end
