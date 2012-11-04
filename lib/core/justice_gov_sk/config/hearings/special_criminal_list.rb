module JusticeGovSk
  module Config
    module Hearings
      class SpecialCriminalList
        include JusticeGovSk::Config::ListRequest

        def request_dump_path
          'special_criminal_list_hearings_request_dump'
        end

        def url
          'http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieSpecZoznam.aspx'
        end
      end
    end
  end
end

