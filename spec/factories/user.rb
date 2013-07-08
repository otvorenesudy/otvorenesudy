FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }

    password              'hard_password'
    password_confirmation 'hard_password'
  end
end
