class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @period       = Period.find(params[:period_id])
    @subscription = Subscription.new(params[:subscription])

    @subscription.user   = current_user
    @subscription.period = @period

    if @subscription.save
      flash[:success] = t('.subscriptions.create.success')
    else
      flash[:failure] = t('.subscriptions.create.failure')
    end

    redirect_to :back
  end

  def update
    @subscription = Subscription.find(params[:id])

    @subscription.period = Period.find(params[:period_id])

    if @subscription.save
      flash[:success] = t('.subscriptions.update.success')
    else
      flash[:failure] = t('.subscriptions.update.failure')
    end

    redirect_to :back
  end

  def destroy
    @subscription = Subscription.find(params[:id])

    @subscription.destroy

    flash[:notice] = t('.subscriptions.delete.notice')

    redirect_to :back
  end
end
