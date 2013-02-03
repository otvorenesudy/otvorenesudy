module JusticeGovSk
  class Request
    class JudgeList < JusticeGovSk::Request::List
      def self.url
        @url ||= "#{super}/Stranky/Sudcovia/SudcaZoznam.aspx"
      end
    end
  end
end
