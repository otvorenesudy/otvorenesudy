# frozen_string_literal: true

# Error pages, rendered through config.exceptions_app (which requests /<status>) in the site's layout and the
# visitor's language.
class ErrorsController < ApplicationController
  def show
    @status = Rack::Utils::HTTP_STATUS_CODES.key?(params[:status].to_i) ? params[:status].to_i : 500

    scope = [:exceptions, Rack::Utils::SYMBOL_TO_STATUS_CODE.key(@status)]
    @title = t(:title, scope:, default: Rack::Utils::HTTP_STATUS_CODES[@status])
    @description = t(:description, scope:, default: '')

    render status: @status, formats: :html
  end
end
