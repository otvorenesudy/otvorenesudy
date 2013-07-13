FactoryGirl.define do
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

    street 'Street'

    source
    municipality

    type { create :court_type }
  end
end
