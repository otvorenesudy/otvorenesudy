module JusticeGovSk
  module Config
    module Hearings
      class CriminalHearingList
        include JusticeGovSk::Config::ListRequest

        def url
          "#{JusticeGovSk::Config::URL.base}/Stranky/Pojednavania/PojednavanieTrestZoznam.aspx"
        end
      end
    end
  end
end
