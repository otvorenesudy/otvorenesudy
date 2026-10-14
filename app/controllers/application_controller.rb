# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale

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

  # Pages warn about several things at once: each call adds a message of the type.
  def flash_now(type, message)
    flash.now[type] = [*flash.now[type], message]
  end

  # ?l=sk or ?l=en for the request; any other language goes to the home page.
  def switch_locale(&)
    locale = params[:l].presence || I18n.default_locale

    return redirect_to(root_path) unless I18n.available_locales.map(&:to_s).include?(locale.to_s)

    I18n.with_locale(locale, &)
  end
end
