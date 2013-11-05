class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || subscriptions_users_path
  end

  def after_sign_out_path_for(resource)
    new_session_path(resource_name)
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
