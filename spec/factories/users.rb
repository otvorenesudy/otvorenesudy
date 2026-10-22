# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'correct horse battery' }
    password_confirmation { password }
    confirmed_at { Time.current }

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :admin do
      admin { true }
    end
  end

  factory :query do
    model { 'Decree' }
    value { {} }

    trait :hearings do
      model { 'Hearing' }
    end
  end

  factory :subscription do
    user
    query
    period { Period.monthly }

    trait :daily do
      period { Period.daily }
    end

    trait :weekly do
      period { Period.weekly }
    end
  end
end
