module Probe
  def self.client
    @client ||= Elasticsearch::Client.new(
      url: Rails.application.credentials.dig(:elasticsearch, :url) || 'http://localhost:9200',
      log: Rails.env.development?
    )
  end
end
