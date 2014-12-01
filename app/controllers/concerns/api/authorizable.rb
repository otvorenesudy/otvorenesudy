module Api
  module Authorizable
    extend ActiveSupport::Concern

    included do
      before_filter :check_api_key
    end

    private

    def check_api_key
      unless ApiKey.exists? value: params[:api_key]
        render status: 401, json: { success: false, errors: ['Invalid API Key'] }
      end
    end
  end
end
