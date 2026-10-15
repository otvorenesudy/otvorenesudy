# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def subscriptions
    @hearing_subscriptions = current_user.subscriptions.by_model(Hearing).latest
    @decree_subscriptions = current_user.subscriptions.by_model(Decree).latest
  end
end
