module Bing
  module Cache
    def self.get(key)
      cache[key]
    end

    def self.store(key, value)
      cache[key] = value
    end

    def self.delete(key)
      cache[key] = nil
    end

    def self.cache
      @cache ||= Hash.new
    end
  end
end
