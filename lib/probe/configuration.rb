# frozen_string_literal: true

module Probe
  # config/probe.yml, and how to reach Elasticsearch: ELASTICSEARCH_URL or the elasticsearch credentials (url, api_key,
  # ca_fingerprint), else a local node without security.
  module Configuration
    module_function

    def indices
      data.fetch(:indices)
    end

    def settings
      data.fetch(:settings)
    end

    def client
      credentials = Rails.application.credentials.elasticsearch || {}

      {
        url: ENV['ELASTICSEARCH_URL'] || credentials[:url] || 'http://localhost:9200',
        api_key: credentials[:api_key],
        ca_fingerprint: credentials[:ca_fingerprint],
        request_timeout: 60,
        retry_on_failure: 2
      }.compact
    end

    def data
      @data ||= Rails.application.config_for(:probe).deep_symbolize_keys
    end
  end
end
