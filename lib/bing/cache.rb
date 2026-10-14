# frozen_string_literal: true

module Bing
  # Responses by URL, for the life of the process.
  module Cache
    module_function

    def get(key)
      cache[key]
    end

    def store(key, value)
      cache[key] = value
    end

    def delete(key)
      cache.delete(key)
    end

    def cache
      @cache ||= {}
    end
  end
end
