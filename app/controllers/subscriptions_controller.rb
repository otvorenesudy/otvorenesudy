# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: %i[unsubscription unsubscribe]
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

  # The e-mail's link: its token moves to the session and the visitor to an address without it, so Analytics, og:url
  # and the confirmation's Referer never see it. There the page asks to confirm.
  def unsubscription
    if params.key?(:token)
      session[:unsubscribe_token] = params[:token].to_s

      return redirect_to unsubscribe_subscriptions_path
    end

    @subscription = unsubscribed(session[:unsubscribe_token])
  end

  # The confirmation sends the token in the form, the mail client's one-click request in the address.
  def unsubscribe
    @subscription = unsubscribed(params[:token])
    @subscription&.destroy!

    session.delete(:unsubscribe_token) if @subscription && session[:unsubscribe_token] == @subscription.token
  end

  private

  def unsubscribed(token)
    Subscription.find_by(token: token.to_s) if token.present?
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
