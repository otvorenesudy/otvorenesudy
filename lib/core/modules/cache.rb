module Cache
  include Storage

  attr_accessor :expire_time

  def root
    @root ||= Configuration.cache.root
  end
    
  def expired?(path)
    (Time.now - File.ctime(fullpath(path))) >= @expire_time unless @expire_time.nil?
  end

  def load(path)
    super(path) unless expired?(path)
  end
end
