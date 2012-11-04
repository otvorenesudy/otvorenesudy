module JusticeGovSk
  module Config
    module Hearings
      class CivilList
        include JusticeGovSk::Config::ListRequest

        def request_dump_path
          'civil_list_hearings_request_dump'
        end

        def url
          'http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieZoznam.aspx'
        end
      end
    end
  end
end

