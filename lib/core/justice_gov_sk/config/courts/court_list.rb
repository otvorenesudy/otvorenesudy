module JusticeGovSk
  module Config
    module Courts
      class CourtList < JusticeGovSk::Config::ListRequest
        def url
          "#{JusticeGovSk::Config::URL.base}/Stranky/Sudy/SudZoznam.aspx"
        end
      end
    end
  end
end
