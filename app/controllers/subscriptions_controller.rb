# encoding: utf-8

class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @period       = Period.find(params[:period_id])
    @subscription = Subscription.new(params[:subscription])

    @subscription.user   = current_user
    @subscription.period = @period

    if @subscription.save
      flash[:success] = t('.subscription_successful')
    else
      flash[:error] = t('.subscription_error')
    end

    redirect_to :back
  end

  def update
    @subscription = Subscription.find(params[:id])

    @subscription.period = Period.find(params[:period_id])

    if @subscription.save
      flash[:success] = t('.subscription_updated')
    else
      flash[:error] = t('.subscription_update_error')
    end

    redirect_to :back
  end

  def destroy
    @subscription = Subscription.find(params[:id])

    @subscription.destroy

    flash[:notice] = t('.subscription_cancelled')

    redirect_to :back
  end
end
