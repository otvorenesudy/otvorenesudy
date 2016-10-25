class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do
    flash_message_wrap keys: %i(danger warning info)
  end

  before_filter do
    set_locale params[:l] || I18n.default_locale
  end

  protected

  include FlashHelper

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || subscriptions_users_path
  end

  def after_sign_out_path_for(resource)
    new_session_path(resource_name)
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def default_url_options(options = {})
    { l: I18n.locale }
  end

  def set_locale(value)
    I18n.locale = value
  rescue I18n::InvalidLocale
    redirect_to :root
  end
end
