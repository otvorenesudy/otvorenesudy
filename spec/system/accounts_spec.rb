# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Accounts' do
  let(:password) { 'correct horse battery' }

  def field(attribute)
    User.human_attribute_name(attribute)
  end

  # The link in the last e-mail sent to the address that leads to the path.
  def link_in_mail_to(email, path)
    mail = ActionMailer::Base.deliveries.rfind { |delivery| delivery.to == [email] }
    html = mail.html_part&.body&.decoded || mail.body.decoded

    Capybara.string(html).all('a').map { |link| link[:href] }.find { |href| href.include?(path) }
  end

  def sign_in_with(email, secret)
    visit new_user_session_path
    fill_in field(:email), with: email
    fill_in field(:password), with: secret
    click_button I18n.t('devise.sessions.new.submit')
  end

  it 'signs up, and confirms the e-mail address by the link in the e-mail' do
    visit new_user_registration_path
    fill_in field(:email), with: 'nova@example.com'
    fill_in field(:password), with: password
    fill_in field(:password_confirmation), with: password
    click_button I18n.t('devise.registrations.new.submit')

    expect(page).to have_text(I18n.t('devise.registrations.signed_up'))
    expect(User.find_by!(email: 'nova@example.com')).not_to be_confirmed

    visit link_in_mail_to('nova@example.com', user_confirmation_path)

    expect(page).to have_text(I18n.t('devise.confirmations.confirmed'))
    expect(User.find_by!(email: 'nova@example.com')).to be_confirmed
  end

  it 'refuses a sign-up with a password too short' do
    visit new_user_registration_path
    fill_in field(:email), with: 'nova@example.com'
    fill_in field(:password), with: 'short'
    fill_in field(:password_confirmation), with: 'short'
    click_button I18n.t('devise.registrations.new.submit')

    expect(page).to have_css('.alert-danger', text: field(:password))
    expect(User.count).to eq(0)
  end

  it 'signs in to the subscriptions and signs out' do
    create(:user, email: 'citatel@example.com', password:)

    sign_in_with('citatel@example.com', password)

    expect(page).to have_current_path(subscriptions_users_path(l: :sk))

    click_on I18n.t('layouts.header.sign_out')

    expect(page).to have_link(I18n.t('layouts.header.sign_in'))
  end

  it 'refuses a wrong password' do
    create(:user, email: 'citatel@example.com', password:)

    sign_in_with('citatel@example.com', 'wrong password')

    expect(page).to have_css('.alert', text: I18n.t('devise.failure.invalid', authentication_keys: field(:email)))
  end

  it 'resets a forgotten password by e-mail' do
    create(:user, email: 'citatel@example.com', password:)

    visit new_user_password_path
    fill_in field(:email), with: 'citatel@example.com'
    click_button I18n.t('devise.passwords.new.send_instructions')
    visit link_in_mail_to('citatel@example.com', edit_user_password_path)
    fill_in I18n.t('devise.passwords.edit.new_pass'), with: 'a brand new secret'
    fill_in I18n.t('devise.passwords.edit.new_pass_confirmation'), with: 'a brand new secret'
    click_button I18n.t('devise.passwords.edit.change_pass')

    expect(page).to have_text(I18n.t('devise.passwords.updated'))

    click_on I18n.t('layouts.header.sign_out')
    sign_in_with('citatel@example.com', 'a brand new secret')

    expect(page).to have_current_path(subscriptions_users_path(l: :sk))
  end

  it 'changes the password with the current one' do
    user = create(:user, email: 'citatel@example.com', password:)
    login_as user

    visit edit_user_registration_path
    fill_in field(:password), with: 'a brand new secret'
    fill_in field(:password_confirmation), with: 'a brand new secret'
    fill_in field(:current_password), with: password
    click_button I18n.t('devise.registrations.edit.submit')

    expect(page).to have_text(I18n.t('devise.registrations.updated'))
    expect(user.reload).to be_valid_password('a brand new secret')
  end

  it 'deletes the account with its subscriptions' do
    user = create(:user)
    create(:subscription, user:)
    login_as user

    visit edit_user_registration_path
    click_button I18n.t('devise.registrations.edit.confirm_delete')

    expect(page).to have_text(I18n.t('devise.registrations.destroyed'))
    expect(User.count).to eq(0)
    expect(Subscription.count).to eq(0)
  end
end
