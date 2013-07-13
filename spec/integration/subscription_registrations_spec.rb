# encoding: utf-8
require 'spec_helper'

describe 'SubscriptionRegistrations' do
  let!(:user) { create :user }

  before :each do
    login_as user, scope: :user
  end

  after :all do
    ProbeHelper.delete
  end

  context 'when searching' do
    after :each do
      page.should have_content('Odoberanie bolo úspešne zaregistrované.')
    end

    it 'should register notification for empty query' do
      visit search_decrees_path

      within '#subscribe' do
        click_button 'new_subscription'
      end

      subscription = user.subscriptions.first

      subscription.period.should      eql(Period.find_by_name(:monthly))
      subscription.query.value.should eql({})
      subscription.query.model.should eql('Decree')
    end

    it 'should register weekly notification for empty query' do
      visit search_decrees_path

      within '#subscribe' do
        choose 'period-weekly'
        click_button 'new_subscription'
      end

      subscription = user.subscriptions.first

      subscription.period.name.should eql('weekly')
      subscription.query.value.should eql({})
      subscription.query.model.should eql('Decree')
    end

    it 'should register query' do
      decree = create :decree

      ProbeHelper.reload

      visit search_decrees_path

      within '#search-view #decree-court' do
        click_link decree.court.name
      end

      within '#subscribe' do
        choose 'period-daily'
        click_button 'new_subscription'
      end

      subscription = user.subscriptions.first

      subscription.period.name.should eql('daily')
      subscription.query.value.should eql({ court: decree.court.name })
      subscription.query.model.should eql('Decree')
    end
  end
end
