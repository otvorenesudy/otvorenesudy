module JusticeGovSk
  module Config
    module Decrees
      class DecreeList
        include JusticeGovSk::Config::ListRequest

        def url
          'http://www.justice.gov.sk/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutia.aspx'
        end
      end
    end
  end
end

