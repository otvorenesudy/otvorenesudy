module JusticeGovSk
  class Request
    class CriminalHearingList < JusticeGovSk::Request::HearingList
      def url
        @url ||= "#{super}/Stranky/Pojednavania/PojednavanieTrestZoznam.aspx"
      end
    end
  end
end
