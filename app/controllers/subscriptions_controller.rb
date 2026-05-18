class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: :unsubscribe
  skip_before_action :verify_authenticity_token, only: :unsubscribe

  def create
    @period = Period.find(params[:period_id])
    @subscription = Subscription.new(subscription_params)

    @subscription.user = current_user
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

  def unsubscribe
    @subscription = Subscription.find_by(token: unsubscribe_params[:token])

    @subscription.destroy if @subscription

    flash[:notice] = t('.subscriptions.mailer.results.unsubscribed.notice')

    redirect_to root_path
  end

  private

  def subscription_params
    params.require(:subscription).permit(:query_attributes)
  end

  def unsubscribe_params
    params.permit(:token)
  end
end
