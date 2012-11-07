# encoding: utf-8

module JusticeGovSk
  module Parsers
    class CivilHearingParser < HearingParser
      def type(document)
        'Civilné'
      end
    end
  end
end
