# frozen_string_literal: true

# Rails.cache is a null store in tests. Examples about what the app keeps or counts across requests (`cache: true`)
# get a memory store of their own, as production has memcached.
RSpec.configure do |config|
  config.around(cache: true) do |example|
    original = Rails.cache
    Rails.cache = ActiveSupport::Cache::MemoryStore.new
    example.run
  ensure
    Rails.cache = original
  end
end
