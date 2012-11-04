module JusticeGovSk
  module Config
    module Judges
      class List
        include JusticeGovSk::Config::ListRequest

        def request_dump_path
          'list_judges_request_dump'
        end

        def url
          'http://www.justice.gov.sk/Stranky/Sudcovia/SudcaZoznam.aspx'
        end
      end
    end
  end
end

