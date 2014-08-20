FactoryGirl.define do
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

    type { CourtType.all.sample }

    trait :with_employments do
      after :create do |court|
        (Random.rand(10) + 1).times.map { create :employment, :active, court: court }
      end
    end
  end
end
