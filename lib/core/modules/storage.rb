require 'murmurhash3'

module Storage
  attr_accessor :root,
                :binary,
                :distribute
  
  def root
    @root ||= 'storage'
  end
  
  def binary
    @binary.nil? ? false : @binary
  end
  
  def distribute
    @distribute.nil? ? false : @distribute
  end

  def load(path)
    path = fullpath(path)
    
    File.open(path, binary ? 'rb' : 'r:utf-8').read if File.readable? path
  end
  
  def store(path, content)
    path = fullpath(path)
    
    FileUtils.mkpath File.dirname(path) unless Dir.exists? File.dirname(path)
    
    File.open(path, binary ? 'wb' : 'w:utf-8') do |file|
      file.write binary ? content : content.force_encoding('utf-8')
      file.flush
    end
  end
  
  def fullpath(path)
    filename = File.basename(path)
    
    File.join root, File.dirname(path), bucket(filename).to_s, filename
  end
  
  private
  
  def bucket(filename)
    hash(filename).to_s(16) if distribute
  end
  
  def hash(s)
    MurmurHash3::V32.str_hash(s) % 256
  end
end
