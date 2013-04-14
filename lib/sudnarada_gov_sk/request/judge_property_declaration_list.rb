module SudnaradaGovSk
  class Request
    class JudgePropertyDeclarationList < SudnaradaGovSk::Request::List
      def url
        @url ||= "#{super}/majetkove-priznania-sudcov/?page=#{@page}"
      end
    end
  end
end
