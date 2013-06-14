module SudnaradaGovSk
  module URL
    def self.base
      'http://mps.sudnarada.gov.sk'
    end
    
    def self.valid?(url)
      url.start_with? self.base
    end
    
    def self.url_to_path(url, ext = nil)
      uri  = URI.parse(url)
      path = uri.path

      if path =~ /\d+\/\z/
        parts = path.split(/\//)
        path  = "#{parts.last.match(/\d+\z/)[0]}/#{parts.second}"
      else
        path.gsub!(/\//, '')
      end
      
      path.downcase!
      
      "#{path}.#{ext || :html}" unless path.blank?
    end
  end
end
