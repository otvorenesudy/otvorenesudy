class Api::ApplicationController < ActionController::Base
  include Api::Authorizable

  protect_from_forgery with: :null_session

  respond_to :json

  protected

  def serialization_scope
    self
  end
end
