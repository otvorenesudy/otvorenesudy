# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: %i[unsubscription unsubscribe]
  before_action :set_unsubscribed, only: %i[unsubscription unsubscribe]
  before_action :set_subscription, only: %i[update destroy]

  # Mail clients unsubscribe by a POST of their own (List-Unsubscribe-Post), without a form.
  skip_forgery_protection only: :unsubscribe

  def create
    subscription = current_user.subscriptions.new(subscription_params.merge(period:))

    if subscription.save
      flash[:success] = t('.success')
    else
      flash[:failure] = t('.failure')
    end

    redirect_back_or_to subscriptions_users_path
  end

  def update
    if @subscription.update(period:)
      flash[:success] = t('.success')
    else
      flash[:failure] = t('.failure')
    end

    redirect_back_or_to subscriptions_users_path
  end

  def destroy
    @subscription.destroy!

    redirect_back_or_to subscriptions_users_path, notice: t('subscriptions.delete.notice')
  end

  # The e-mail's link: asks to confirm.
  def unsubscription; end

  def unsubscribe
    @subscription&.destroy!
  end

  private

  def set_unsubscribed
    @subscription = Subscription.find_by(token: params[:token].to_s) if params[:token].present?
  end

  def set_subscription
    @subscription = current_user.subscriptions.find(params.expect(:id))
  end

  def period
    Period.find(params.expect(:period_id))
  end

  def subscription_params
    params.expect(subscription: [{ query_attributes: %i[model value] }])
  end
end
