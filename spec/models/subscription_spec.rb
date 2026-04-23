require 'spec_helper'

describe Subscription do
  describe 'token' do
    it 'should auto-generate a unique token on create' do
      subscription = create :subscription, :weekly, :with_empty_query

      subscription.token.should be_present
    end

    it 'should generate distinct tokens for distinct subscriptions' do
      a = create :subscription, :weekly, :with_empty_query
      b = create :subscription, :daily, :with_empty_query, user: a.user

      a.token.should_not eql(b.token)
    end
  end

  describe '#notify' do
    before :each do
      MailerHelper.reset_email
    end

    after :all do
      delete_indices
    end

    it 'should deliver subscription to query with new documents' do
      document = create :decree
      subscription = create :subscription, :weekly, :with_empty_query

      document.created_at = Time.now

      document.save!

      reload_indices

      subscription.notify

      subscription.results.should eql([document])
      MailerHelper.last_email.to.should eql([subscription.user.email])
    end

    it 'should not deliver subscription when no results found' do
      document = create :decree
      subscription = create :subscription, :weekly, :with_empty_query

      document.created_at = 2.weeks.ago
      document.save!

      reload_indices

      subscription.notify

      subscription.results.should be_empty
      MailerHelper.last_email.should be_nil
    end

    it 'should deliver mail for subscription with complex query' do
      document = create :hearing
      subscription = create :subscription, :weekly, :with_query_for_hearing

      reload_indices

      subscription.notify

      subscription.results.should eql([document])
      MailerHelper.last_email.to.should eql([subscription.user.email])
    end
  end
end
