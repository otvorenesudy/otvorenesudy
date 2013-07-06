class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def after_sign_in_path_for(resource_or_scope)
    # TODO change to subscription managment
    stored_location_for(resource_or_scope) || edit_user_registration_path
  end
      
  def after_sign_out_path_for(resource_or_scope)
    new_session_path(resource_name)
  end
end
