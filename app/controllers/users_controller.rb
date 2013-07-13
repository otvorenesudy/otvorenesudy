class UsersController < ApplicationController
  before_filter :authenticate_user!

  def subscriptions
    @user          = current_user
    @subscriptions = @user.subscriptions.newest
  end
end
