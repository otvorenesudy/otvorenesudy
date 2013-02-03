module JusticeGovSk
  class Request
    class CourtList < JusticeGovSk::Request::List
      def self.url
        @url ||= "#{super}/Stranky/Sudy/SudZoznam.aspx"
      end
    end
  end
end
