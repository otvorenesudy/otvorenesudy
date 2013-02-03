module JusticeGovSk
  class Request
    class CivilHearingList < JusticeGovSk::Request::HearingList
      def self.url
        @url ||= "#{super}/Stranky/Pojednavania/PojednavanieZoznam.aspx"
      end
    end
  end
end
