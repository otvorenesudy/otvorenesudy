module JusticeGovSk
  module URL
    def self.base
      JusticeGovSk.source.uri
    end

    def self.valid?(url)
      url.start_with? self.base
    end

    def self.url_to_path(url, ext = nil)
      uri  = URI.parse(url)
      path = uri.path

      path.gsub!(/Stranky\/Sudy/i,              '')
      path.gsub!(/Stranky\/Pojednavania/i,      '')
      path.gsub!(/Stranky\/Sudne-rozhodnutia/i, '')

      path.gsub!(/(?<court>[\-\w]+)\/SudDetail/i, 'court-\k<court>')
      path.gsub!(/PojednavanieDetail/i,           'civil-hearing')
      path.gsub!(/PojednavanieTrestDetail/i,      'criminal-hearing')
      path.gsub!(/PojednavanieSpecDetail/i,       'special-hearing')
      path.gsub!(/Sudne-rozhodnutie-detail/i,     'decree')

      path.gsub!(/\//, '')

      path.downcase!

      path = "#{path}?#{uri.query}" unless uri.query.nil?
      "#{path}.#{ext || :html}" unless path.blank?
    end
    
    def self.path_to_url(path)
      name = File.basename path, '.html'

      name.gsub!(/civil-hearing/i,    'Pojednavania/PojednavanieDetail')
      name.gsub!(/criminal-hearing/i, 'Pojednavania/PojednavanieTrestDetail')
      name.gsub!(/special-hearing/i,  'Pojednavania/PojednavanieSpecDetail')
      name.gsub!(/decree/i,           'Sudne-rozhodnutia/Sudne-rozhodnutie-detail')

      "#{self.base}/Stranky/#{name}"
    end
  end
end
