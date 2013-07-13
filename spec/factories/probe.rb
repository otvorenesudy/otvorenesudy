FactoryGirl.define do
  factory :employment do
    trait :active do
      active true
    end

    trait :inactive do
      active false
    end

    trait :unknown do
      active nil
    end

    court
  end

  factory :judge do
    sequence(:name) { |n| "JUDr. Peter Retep #{n}" }

    sequence(:name_unprocessed) { |n| "JUDr. Peter Retep #{n}" }

    prefix   'JUDr.'
    first    'Peter'
    middle   ''
    last     'Retep'
    suffix   'PhD.'
    addition ''

    sequence(:uri) { |n| "factory_girl_judge_#{n}" }

    source

    after :create do |judge|
      create :employment, :active, judge: judge
    end
  end
end
