module JusticeGovSk
  class Downloader
    include Core::Downloader
    
    def headers
      JusticeGovSk::Request.headers
    end
    
    protected
    
    def uri_to_path(uri)
      JusticeGovSk::URL.url_to_path(uri, :html)
    end
  end
end
