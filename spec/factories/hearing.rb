FactoryGirl.define do
  factory :hearing_type do
    sequence(:value) { |n| "Hearing Type #{n}" }
  end

  factory :hearing do
    source

    sequence(:uri) { |n| "factory_girl_hearing_uri_#{n}" }

    case_number 'case_number'
    file_number 'file_number'
    date         Time.now

    type { create :hearing_type }
  end
end
