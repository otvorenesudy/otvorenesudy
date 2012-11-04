module JusticeGovSk
  module Config
    module Hearings
      class CriminalList
        include JusticeGovSk::Config::Request

        def request_dump_path
          'criminal_list_hearings_request_dump'
        end

        def url
          'http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieTrestZoznam.aspx'
        end
      end
    end
  end
end
