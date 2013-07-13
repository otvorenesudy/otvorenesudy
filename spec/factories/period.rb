FactoryGirl.define do
  factory :period do
    trait :daily do
      name  :daily
      value 1.day.to_i
    end

    trait :weekly do
      name  :weekly
      value 1.week.to_i
    end

    trait :monthly do
      name  :monthly
      value 1.month.to_i
    end
  end
end
