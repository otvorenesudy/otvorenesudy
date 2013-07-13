class UsersController < ApplicationController
  before_filter :authenticate_user!

  def subscriptions
    @user = current_user

    @hearing_subscriptions = @user.subscriptions.by_model(Hearing).latest
    @decree_subscriptions  = @user.subscriptions.by_model(Decree).latest
  end
end
