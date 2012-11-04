module JusticeGovSk
  module Config
    module Hearings
      class CivilHearingList
        include JusticeGovSk::Config::ListRequest

        def url
          'http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieZoznam.aspx'
        end
      end
    end
  end
end

