class Probe::Index
  module Creation
    def create(name = nil)
      index = index(name)

      index.create(mappings: mapping_to_hash, settings: settings) unless index.exists?

      index
    end

    def delete(name = nil)
      index(name).delete
    end

    def exists?(name = nil)
      index(name).exists?
    end

    def refresh(name = nil)
      index(name).refresh
    end

    def import(name = nil, collection = base)
      index(name).import(collection, method: :paginate, per_page: 5000)

      refresh
    end

    def update(collection = base)
      block = lambda { |record| record.probe.update }

      collection.respond_to?(:each) ? collection.each(&block) : collection.find_each(&block)
    end

    def reload(name = nil)
      delete(name)
      create(name)

      import
    end

    def store(record)
      index.store(record)
    end
  end
end
