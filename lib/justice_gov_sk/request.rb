module JusticeGovSk
  class Request # TODO < Core::Request
    attr_accessor :url
    
    def url
      JusticeGovSk::URL::base
    end
  end
end
