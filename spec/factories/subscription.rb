FactoryGirl.define do
  factory :subscription do
    user

    trait :daily do
      period { Period.daily }
    end

    trait :weekly do
      period { Period.weekly }
    end

    trait :monthly do
      period { Period.monthly }
    end

    trait :with_empty_query do
      query { create :query, :empty }
    end

    trait :with_query_for_hearing do
      query { create :query, :for_hearing }
    end

    trait :with_query_for_decree do
      query { create :query, :for_decree }
    end
  end
end
