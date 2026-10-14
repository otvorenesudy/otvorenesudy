# frozen_string_literal: true

# Bing web search for news about courts and judges (Resource::ContextSearch, commented out since 2019). It calls the
# Azure DataMarket API, which Microsoft shut down in 2017, so searches find nothing.
module Bing
  def self.api_key
    Rails.application.credentials.dig(:bing, :key)
  end
end
