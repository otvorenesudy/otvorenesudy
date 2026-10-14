# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include FlashHelper

  before_action { flash_message_wrap keys: %i[danger warning info] }
  before_action :set_locale

  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || subscriptions_users_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_session_path(Devise::Mapping.find_scope!(resource_or_scope))
  end

  def default_url_options
    { l: I18n.locale }
  end

  private

  # ?l=sk or ?l=en; any other language goes to the home page.
  def set_locale
    locale = params[:l].presence || I18n.default_locale

    return I18n.locale = locale if I18n.available_locales.map(&:to_s).include?(locale.to_s)

    I18n.locale = I18n.default_locale
    redirect_to root_path
  end
end
