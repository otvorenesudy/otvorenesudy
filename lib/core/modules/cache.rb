module Cache
  attr_accessor :root
  
  def root
    @root || './tmp/cache/downloads'
  end

  def load(path)
    File.open(path, 'r:utf-8').read if File.readable? path
  end
    
  def store(path, content)
    File.open(path, 'w:utf-8') do |file|
      file.write content.force_encoding('utf-8')
      file.flush
    end
  end

  def uri_to_path(uri)
    uri  = URI.parse(uri)
    path = "#{root}#{uri.path}"
    
    uri.query.nil? ? path : "#{path}?#{uri.query}"
  end
end
