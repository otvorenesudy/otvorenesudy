module JusticeGovSk
  class Request
    include Core::Request

    attr_accessor :url

    def self.headers
      {
        'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language' => 'en-US,en;q=0.5',
        'Cache-Control'   => 'max-age=0',
        'DNT'             => '1',
        'Connection'      => 'keep-alive',
        'Cookie'          => '__utma=161066278.1871589972.1351081154.1352917575.1352943059.48; __utmz=161066278.1351118484.7.3.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=mssr; ASP.NET_SessionId=t4koyt45ztxjll55ls3cr5z0; __utmc=161066278; __utmb=161066278.1.10.1352943059',
        'Host'            => 'www.justice.gov.sk',
        'User-Agent'      => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:16.0) Gecko/20100101 Firefox/16.0'
      }
    end

    def self.uri(request)
      Core::Request.uri(request)
    end

    def self.url
      @url ||= JusticeGovSk::URL::base
    end

    def initialize(options = {})
    end

    def url
      @url ||= self.class.url.dup
    end
  end
end
