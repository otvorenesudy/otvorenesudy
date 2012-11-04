module JusticeGovSk
  module Config
    module Hearings
      class SpecialHearingList
        include JusticeGovSk::Config::ListRequest

        def url
          'http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieSpecZoznam.aspx'
        end
      end
    end
  end
end
