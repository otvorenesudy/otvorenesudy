module Cache
  include Storage

  attr_accessor :expire_time

  def root
    @root ||= File.join 'tmp', 'cache'
  end
  
  def load(path)
    super(path) unless expired?(path)
  end
  
  def expired?(path)
    (Time.now - File.ctime(fullpath(path))) >= @expire_time unless @expire_time.nil?
  end
end
