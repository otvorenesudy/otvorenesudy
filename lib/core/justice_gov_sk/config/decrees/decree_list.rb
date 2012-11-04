module JusticeGovSk
  module Config
    module Decrees
      class DecreeList
        include JusticeGovSk::Config::ListRequest

        def data_filename
          'decree_list.data'
        end

        def url
          'http://www.justice.gov.sk/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutia.aspx'
        end
      end
    end
  end
end

