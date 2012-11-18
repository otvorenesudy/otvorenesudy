require 'murmurhash3'

module Storage
  attr_accessor :root,
                :binary,
                :distribute
  
  def root
    @root ||= Configuration.storage.root
  end
  
  def binary
    @binary.nil? ? false : @binary
  end
  
  def distribute
    @distribute.nil? ? false : @distribute
  end

  def contains?(path)
    File.exists? fullpath(path)
  end

  def loadable?(path)
    File.readable? fullpath(path)
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
    dir    = File.dirname(path)
    dir    = dir == '.' ? '' : dir 
    file   = File.basename(path)
    bucket = distribute ? Storage::bucket(file) : ''

    File.join root, dir, bucket, file
  end
  
  def self.bucket(file)
    '%02x' % hash(file)
  end
  
  def self.hash(string)
    MurmurHash3::V32.str_hash(string) % 256
  end
end
