class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

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

  def set_locale
    I18n.locale = params[:locale]
  end

  def default_url_options(options={})
    { locale: I18n.locale }
  end
end
