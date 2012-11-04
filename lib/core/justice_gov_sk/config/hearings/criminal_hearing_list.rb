module JusticeGovSk
  module Config
    module Hearings
      class CriminalHearingList
        include JusticeGovSk::Config::ListRequest

        def data_filename
          'criminal_hearing_list.data'
        end

        def url
          'http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieTrestZoznam.aspx'
        end
      end
    end
  end
end
