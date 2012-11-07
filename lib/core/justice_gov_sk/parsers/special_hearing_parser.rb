# encoding: utf-8

module JusticeGovSk
  module Parsers
    class SpecialHearingParser < HearingParser
      def type(document)
        'Špecializovaného trestného súdu'
      end
    end
  end
end
