# encoding: utf-8

module JusticeGovSk
  module Parsers
    class CriminalHearingParser < HearingParser
      def type(document)
        'Trestné'
      end
    end
  end
end
