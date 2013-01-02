module Core
  module Storage
    attr_accessor :root
  
    def contains?(path)
      File.exists? fullpath(path)
    end
  
    def loadable?(path)
      File.readable? fullpath(path)
    end
  
    def load(path)
      path = fullpath(path)
      
      read(path) { |file| file.read } if File.readable? path
    end
    
    def store(path, content)
      path = fullpath(path)
      dir  = File.dirname(path)
      
      FileUtils.mkpath dir unless Dir.exists? dir
      
      write(path) do |file|
        file.write content
        file.flush
      end
    end
    
    def remove(path)
      FileUtils.rm fullpath(path)
    end
    
    def fullpath(path)
      File.join(partition(path).select { |part| part != '.' })
    end
    
    protected

    include Core::Storage::Binary
    
    def partition(path)
      dir  = File.dirname(path)
      file = File.basename(path)

      [root, dir, file] 
    end
  end  
end
