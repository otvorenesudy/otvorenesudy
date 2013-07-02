FactoryGirl.define do
  factory :source do
    sequence(:uri)    { |n| "factory_girl_uri_#{n}" }
    sequence(:name)   { |n| "factory_girl_name_#{n}" }
    sequence(:module) { |n| "factory_girl_module_#{n}" }
  end

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

    court { |e| e.association(:court) }
    judge { |e| e.association(:judge) }
  end

  factory :court_type do
    sequence(:value) { |n| "Court type #{n}" }
  end

  factory :municipality do
    sequence(:name) { |n| "Municipality #{n}" }

    zipcode '0000'
  end

  factory :court do
    sequence(:name) { |n| "Court #{n}" }
    sequence(:uri)  { |n| "court_uri_#{n}" }

    street       'Street'

    type { create :court_type }
    source
    municipality
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

    after(:create) do |judge|
      create :employment, :active, court: create(:court), judge: judge
    end
  end
end
