module Cache
  attr_accessor :root,
                :binary
  
  def root
    @root ||= './tmp/cache/downloads'
  end
  
  def binary
    @binary.nil? ? false : @binary
  end

  def load(path)
    File.open(path, binary ? 'rb' : 'r:utf-8').read if File.readable? path
  end
  
  def store(path, content)
    File.open(path, binary ? 'wb' : 'w:utf-8') do |file|
      file.write binary ? content : content.force_encoding('utf-8')
      file.flush
    end
  end

  def uri_to_path(uri)
    uri  = URI.parse(uri)
    path = "#{root}#{uri.path}"
    
    uri.query.nil? ? path : "#{path}?#{uri.query}"
  end
end
