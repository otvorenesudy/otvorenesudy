module Justicegovsk
  module Config
    module Hearings
      class Criminal
        extend Request

        def self.request_dump_path
          "criminal_hearing_request_dump"
        end

        def self.url
          "http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieTrestZoznam.aspx"
        end
      end
    end
  end
end
