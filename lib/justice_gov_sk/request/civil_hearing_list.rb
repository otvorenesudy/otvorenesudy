module JusticeGovSk
  module Request
    class CivilHearingList < JusticeGovSk::Request::HearingList
      def url
        @url ||= "#{super}/Stranky/Pojednavania/PojednavanieZoznam.aspx"
      end
    end
  end
end
