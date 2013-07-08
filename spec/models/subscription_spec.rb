require 'spec_helper'

describe Subscription do
  context 'when delivering notification' do
    let(:model) { Hearing }
    let(:document) { create :hearing }
    let(:subscription) { build :subscription }

    before :each do
      document.save!

      model.reload_index

      MailerHelper.reset_email
    end

    after :each do
      model.delete_index
    end

    it 'should deliver subscription to query with new documents' do
      document.created_at = Time.now

      document.save!

      subscription.notify

      subscription.results.should include(document)
      MailerHelper.last_email.to.should eql(subscription.user.email)
    end

    it 'should not deliver subscription when no results found' do
      document.created_at = 2.weeks.ago

      document.save!

      subscription.notify

      subscription.results.should be_empty
      MailerHelper.last_email.should be_nil
    end
  end
end
