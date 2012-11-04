module JusticeGovSk
  module Config
    module Decrees
      class List
        include JusticeGovSk::Config::ListRequest

        def request_dump_path
          'list_decrees_request_dump'
        end

        def url
          'http://www.justice.gov.sk/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutia.aspx'
        end
      end
    end
  end
end

