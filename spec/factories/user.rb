FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }

    password              'hard_password'
    password_confirmation 'hard_password'

    confirmed_at { Time.now }
  end
end
