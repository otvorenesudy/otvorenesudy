module SudnaradaGovSk
  class Downloader
    include Core::Downloader
    
    def headers
      SudnaradaGovSk::Request.headers
    end
    
    protected
    
    def uri_to_path(uri)
      SudnaradaGovSk::URL.url_to_path(uri, :html)
    end
  end
end
