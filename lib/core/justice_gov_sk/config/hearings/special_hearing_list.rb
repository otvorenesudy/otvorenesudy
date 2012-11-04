module JusticeGovSk
  module Config
    module Hearings
      class SpecialHearingList
        include JusticeGovSk::Config::ListRequest

        def url
          "#{JusticeGovSk::Config::URL.base}/Stranky/Pojednavania/PojednavanieSpecZoznam.aspx"
        end
      end
    end
  end
end
