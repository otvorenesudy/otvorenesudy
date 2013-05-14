module Bing
  module Cache
    def self.get(key)
      $redis.get(key)
    end

    def self.store(key, value)
      $redis.set(key, value)
    end

    def self.del(key)
      $redis.del(key)
    end
  end
end
