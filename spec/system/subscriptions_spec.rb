# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subscriptions' do
  let(:user) { create(:user) }
  let(:court) { create(:court, name: 'Okresný súd Košice I') }

  def subscribe_modal
    find_by_id('create_subscription', visible: :all)
  end

  describe 'subscribing to a search' do
    it 'saves the search with its period for a signed-in user' do
      create(:hearing, court:)
      refresh_indices
      login_as user

      visit hearings_path(court: ['Okresný súd Košice I'])
      within(subscribe_modal) do
        choose I18n.t('period.weekly'), allow_label_click: true
      end
      click_on I18n.t('search.subscribe.create')

      expect(page).to have_text(I18n.t('subscriptions.create.success'))

      subscription = user.subscriptions.sole

      expect(subscription.period).to eq(Period.weekly)
      expect(subscription.query.model).to eq('Hearing')
      expect(subscription.query.value).to eq(court: ['Okresný súd Košice I'])
    end

    it 'saves the same search once for everyone' do
      create(:subscription, query: create(:query, :hearings, value: { court: ['Okresný súd Košice I'] }))
      login_as user

      visit hearings_path(court: ['Okresný súd Košice I'])
      click_on I18n.t('search.subscribe.create')

      expect(Query.count).to eq(1)
      expect(user.subscriptions.sole.query).to eq(Query.sole)
    end

    it 'asks a visitor to sign in or sign up' do
      visit hearings_path

      expect(subscribe_modal).to have_text(I18n.t('search.subscribe.sign_in_required'))
      expect(subscribe_modal).to have_link(I18n.t('search.subscribe.sign_up'), href: new_user_registration_path(l: :sk))
    end
  end

  describe 'the subscriptions of a user' do
    let!(:subscription) do
      create(:subscription, user:, query: create(:query, :hearings, value: { court: ['Okresný súd Košice I'] }))
    end

    before { login_as user }

    it 'lists the saved searches with their facets' do
      visit subscriptions_users_path

      expect(page).to have_text("#{I18n.t('facets.hearing.court.title')} – Okresný súd Košice I")
      expect(page).to have_link(I18n.t('subscriptions.list.search'), href: /court/)
    end

    it 'changes the period' do
      visit subscriptions_users_path
      choose I18n.t('period.daily'), allow_label_click: true
      click_on I18n.t('subscriptions.list.update')

      expect(page).to have_text(I18n.t('subscriptions.update.success'))
      expect(subscription.reload.period).to eq(Period.daily)
    end

    it 'cancels a subscription' do
      visit subscriptions_users_path
      click_on I18n.t('subscriptions.list.confirm_delete')

      expect(page).to have_text(I18n.t('subscriptions.delete.notice'))
      expect(Subscription.exists?(subscription.id)).to be(false)
    end
  end

  it 'asks a visitor for the subscriptions to sign in' do
    visit subscriptions_users_path

    expect(page).to have_current_path(new_user_session_path)
  end
end
