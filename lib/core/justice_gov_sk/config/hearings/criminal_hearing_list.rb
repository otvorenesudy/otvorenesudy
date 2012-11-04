module JusticeGovSk
  module Config
    module Hearings
      class CriminalHearingList < JusticeGovSk::Config::ListRequest
        def url
          "#{JusticeGovSk::Config::URL.base}/Stranky/Pojednavania/PojednavanieTrestZoznam.aspx"
        end
      end
    end
  end
end
