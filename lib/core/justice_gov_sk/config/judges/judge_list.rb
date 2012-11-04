module JusticeGovSk
  module Config
    module Judges
      class JudgeList
        include JusticeGovSk::Config::ListRequest

        def data_filename
          'judge_list.data'
        end

        def url
          'http://www.justice.gov.sk/Stranky/Sudcovia/SudcaZoznam.aspx'
        end
      end
    end
  end
end

