require 'spec_helper'

describe 'SubscriptionRegistrations' do
  let!(:user) { create :user }

  before :each do
    reload_indices
  end

  after :all do
    delete_indices
  end

  context 'when searching' do
    describe '#new' do
      before :each do
        login_as user
      end

      after :each do
        page.should have_content('Odoberanie notifikácií bolo zaregistrované.')

        logout user
      end

      it 'should register notification for empty query' do
        visit decrees_path

        within '#create_subscription' do
          click_button 'Odoberať'
        end

        subscription = user.subscriptions.first

        subscription.period.should      eql(Period.monthly)
        subscription.query.value.should eql({})
        subscription.query.model.should eql('Decree')
      end

      it 'should register weekly notification for empty query' do
        visit decrees_path

        within '#create_subscription' do
          choose 'Týždenne'
          click_button 'Odoberať'
        end

        subscription = user.subscriptions.first

        subscription.period.name.should eql('weekly')
        subscription.query.value.should eql({})
        subscription.query.model.should eql('Decree')
      end

      it 'should register query from selection' do
        decree = create :decree, date: Date.parse('1991-02-06')

        reload_indices

        visit decrees_path

        within '#decree-court' do
          click_link decree.court.name
        end

        within '#decree-date ul' do
          find('a:first').click
        end

        within '#create_subscription' do
          choose 'Denne'
          click_button 'Odoberať'
        end

        subscription = user.subscriptions.first

        subscription.period.name.should eql('daily')
        subscription.query.model.should eql('Decree')
        subscription.query.value.should eql({ court: [decree.court.name], date: ['1991-02-01..1991-02-28'] })
      end

      it 'should register query from date array selection' do
        2.times.map { |n| create :decree, date: Date.parse("1991-0#{n + 1}-01") }

        reload_indices

        visit decrees_path

        2.times do |n|
          within "#decree-date ul li:nth-child(#{n + 1})" do
            find('a:first').click
          end
        end

        within '#create_subscription' do
          choose 'Týždenne'
          click_button 'Odoberať'
        end

        subscription = user.subscriptions.first

        subscription.period.name.should eql('weekly')
        subscription.query.model.should eql('Decree')
        subscription.query.value.should eql({ date: ['1991-02-01..1991-02-28', '1991-01-01..1991-01-31']})
      end
    end

    describe '#update' do
      after :each do
        page.should have_content('Odoberanie notifikácií bolo aktualizované.')
      end

      it 'should update existing query' do
        subscription = create :subscription, :monthly, :with_empty_query

        login_as subscription.user

        visit decrees_path

        within '#update_subscription' do
          # find('#period-monthly')['checked'].should_not be_nil

          choose 'Týždenne'
          click_button 'Aktualizovať'
        end

        subscription.reload

        subscription.period.name.should eql('weekly')
        subscription.query.value.should eql({})
      end
    end

    describe '#destoy' do
      it 'should destroy existing query' do
        subscription = create :subscription, :monthly, :with_empty_query

        login_as subscription.user

        visit decrees_path

        within '#update_subscription' do
          click_link 'Zrušiť'
        end

        page.should have_content('Odoberanie notifikácií bolo zrušené.')

        Subscription.exists?(subscription.id).should be_false
      end
    end
  end

  context 'when browsing registered notifications' do
    describe '#update' do
      it 'should update subscription with empty query' do
        subscription = create :subscription, :weekly, :with_empty_query

        login_as subscription.user

        visit subscriptions_users_path

        within "#edit_subscription_#{subscription.id}" do
          choose 'Denne'
          click_button 'Aktualizovať'
        end

        subscription.reload

        subscription.period.name.should eql('daily')
        subscription.query.value.should eql({})

        page.should have_content('Odoberanie notifikácií bolo aktualizované.')
      end
    end

    describe '#destroy' do
      it 'should destroy subscription with empty query' do
        subscription = create :subscription, :daily, :with_empty_query

        login_as subscription.user

        visit subscriptions_users_path

        within "#edit_subscription_#{subscription.id}" do
          click_link 'Zrušiť'
        end

        page.should have_content('Odoberanie notifikácií bolo zrušené.')
        Subscription.exists?(subscription.id).should be_false
      end
    end
  end
end
