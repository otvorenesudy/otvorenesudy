module JusticeGovSk
  module Config
    module Hearings
      class CriminalHearingList
        include JusticeGovSk::Config::ListRequest

        def url
          'http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieTrestZoznam.aspx'
        end
      end
    end
  end
end
