module JusticeGovSk
  module Worker
    extend ActiveSupport::Concern

    included do
      include Sidekiq::Worker
      extend SidekiqClient
    end

    module SidekiqClient
      def client_push(item)
        pool = Thread.current[:sidekiq_via_pool] || get_sidekiq_options['pool'] || Sidekiq.redis_pool

        type = item['args'].first.to_s.underscore.split(/_/).last
        queue = "#{type.underscore}-#{sidekiq_options_hash['queue']}"
        patch = item['args'].last[:queue]

        queue = "#{patch}-#{queue}" unless patch.nil?

        item.merge!(queue: queue)

        Sidekiq::Client.new(pool).push(item.stringify_keys)
      end
    end
  end
end
