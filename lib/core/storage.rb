module Core
  module Storage
    attr_accessor :root

    def contains?(entry)
      File.exists? path(entry)
    end

    def readable?(entry)
      File.readable? path(entry)
    end

    def expired?(entry)
      false
    end

    def load(entry)
      path = path(entry)

      read(path) { |file| file.read } if File.readable? path
    end

    def unload(entry)
      content = load(entry)

      remove(entry)
      content
    end

    def store(entry, content)
      path = path(entry)
      dir  = File.dirname(path)

      FileUtils.mkpath dir

      write(path) do |file|
        file.write content
        file.flush
      end
    end

    def remove(entry)
      FileUtils.remove_entry_secure path(entry)
    end

    def path(entry)
      File.join(partition(entry).select { |part| part != '.' })
    end

    def each
      Dir.foreach(root) do |entry|
        yield entry unless entry.start_with? '.'
      end
    end

    protected

    include Core::Storage::Binary

    def partition(entry)
      dir  = File.dirname(entry)
      file = File.basename(entry)

      [root, dir, file]
    end
  end
end
