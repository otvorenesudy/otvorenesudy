class UsersController < ApplicationController
  before_filter :authenticate_user!

  def subscriptions
    @user          = current_user
    @subscriptions = @user.subscriptions
  end
end
