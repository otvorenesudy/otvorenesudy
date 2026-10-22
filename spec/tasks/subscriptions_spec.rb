# frozen_string_literal: true

require 'rails_helper'
require 'rake'

# The scheduled e-mails of new results (config/schedule.rb runs subscriptions:run[daily|weekly|monthly]).
RSpec.describe 'subscriptions:run', type: :task do
  include Rails.application.routes.url_helpers

  let(:court) { create(:court, name: 'Okresný súd Košice I') }
  let(:query) { create(:query, value: { court: ['Okresný súd Košice I'] }) }

  before do
    Rails.application.load_tasks unless Rake::Task.task_defined?('subscriptions:run')
  end

  # Links in e-mails, as the mailer makes them.
  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  # The e-mails the task sends (creating an unconfirmed user sends one of Devise's).
  def run(period)
    sent = ActionMailer::Base.deliveries.size

    perform_enqueued_jobs { Rake::Task['subscriptions:run'].tap(&:reenable).invoke(period) }

    ActionMailer::Base.deliveries.drop(sent)
  end

  def decree(created_at:, at: court)
    create(:decree, court: at, created_at:).tap(&:update_index)
  end

  def html(mail)
    Capybara.string(mail.html_part&.body&.decoded || mail.body.decoded)
  end

  it 'e-mails a subscriber the new decrees of their search' do
    create(:subscription, :weekly, query:, user: create(:user, email: 'citatel@example.com'))
    new = decree(created_at: 2.days.ago)
    decree(created_at: 2.weeks.ago)
    decree(created_at: 2.days.ago, at: create(:court))
    refresh_indices

    mail = run('weekly').sole

    expect(mail.to).to eq(['citatel@example.com'])
    expect(mail.subject).to eq(I18n.t('subscriptions.mailer.results.subject.decrees'))
    expect(html(mail)).to have_css('.search-result-item', count: 1)
    expect(html(mail)).to have_link(href: decree_url(new))
    expect(html(mail)).to have_css('h1[style]')
  end

  it 'e-mails a subscriber the new hearings of their search, linked to the site' do
    hearings = create(:query, :hearings, value: { court: ['Okresný súd Košice I'] })
    create(:subscription, :weekly, query: hearings)
    hearing = create(:hearing, court:, created_at: 2.days.ago).tap(&:update_index)
    refresh_indices

    mail = run('weekly').sole

    expect(mail.subject).to eq(I18n.t('subscriptions.mailer.results.subject.hearings'))
    expect(html(mail)).to have_link(href: hearing_url(hearing))
    expect(html(mail)).to have_link('Okresný súd Košice I', href: court_url(court))
  end

  it 'links the e-mail to unsubscribe, for the reader and for the mail client' do
    subscription = create(:subscription, :weekly, query:)
    decree(created_at: 2.days.ago)
    refresh_indices

    mail = run('weekly').sole
    url = unsubscribe_subscriptions_url(token: subscription.token)

    expect(html(mail)).to have_link(I18n.t('subscriptions.mailer.results.unsubscribe.link'), href: url)
    expect(mail['List-Unsubscribe'].value).to eq("<#{url}>")
    expect(mail['List-Unsubscribe-Post'].value).to eq('List-Unsubscribe=One-Click')
  end

  it 'e-mails only the subscriptions of the period' do
    create(:subscription, :daily, query:)
    decree(created_at: 2.hours.ago)
    refresh_indices

    expect(run('weekly')).to be_empty
    expect(run('daily').size).to eq(1)
  end

  it 'sends nothing when there is nothing new' do
    create(:subscription, :weekly, query:)
    decree(created_at: 1.month.ago)
    refresh_indices

    expect(run('weekly')).to be_empty
  end

  it 'sends nothing to a user who never confirmed the address' do
    create(:subscription, :weekly, query:, user: create(:user, :unconfirmed))
    decree(created_at: 2.days.ago)
    refresh_indices

    expect(run('weekly')).to be_empty
  end
end
