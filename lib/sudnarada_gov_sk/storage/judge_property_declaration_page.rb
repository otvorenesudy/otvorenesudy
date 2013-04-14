module SudnaradaGovSk
  class Storage
    class JudgePropertyDeclarationPage < SudnaradaGovSk::Storage::Page
      def root
        @root ||= File.join super, 'judge-property-declarations'
      end
    end
  end
end
