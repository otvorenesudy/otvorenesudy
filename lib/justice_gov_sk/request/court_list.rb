module JusticeGovSk
  class Request
    class CourtList < JusticeGovSk::Request::List
      def url
        @url ||= "#{super}/Stranky/Sudy/SudZoznam.aspx"
      end
    end
  end
end
