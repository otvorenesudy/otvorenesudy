module JusticeGovSk
  module Config
    module Decrees
      class DecreeList < JusticeGovSk::Config::ListRequest
        def url
          "#{JusticeGovSk::Config::URL.base}/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutia.aspx"
        end
      end
    end
  end
end

