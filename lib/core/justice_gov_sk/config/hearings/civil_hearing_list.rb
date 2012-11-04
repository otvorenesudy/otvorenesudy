module JusticeGovSk
  module Config
    module Hearings
      class CivilHearingList
        include JusticeGovSk::Config::ListRequest

        def url
          "#{JusticeGovSk::Config::URL.base}/Stranky/Pojednavania/PojednavanieZoznam.aspx"
        end
      end
    end
  end
end

