FactoryGirl.define do
  factory :court_type do
    sequence(:value) { |n| "Court type #{n}" }
  end

  factory :municipality do
    sequence(:name) { |n| "Municipality #{n}" }

    zipcode '0000'
  end


  factory :court do
    uri
    source

    sequence(:name) { |n| "Court #{n}" }

    street 'Street'

    municipality

    type { create :court_type }

    trait :with_employment do
      after :create do |court|
        (Random.rand(10) + 1).times.map { create :employment, :active, court: court }
      end
    end
  end
end
