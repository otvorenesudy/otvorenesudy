module SudnaradaGovSk
  class Agent
    class JudgePropertyDeclaration < SudnaradaGovSk::Agent
      def storage
        @storage ||= SudnaradaGovSk::Storage::JudgePropertyDeclarationPage.instance
      end
    end
  end
end
