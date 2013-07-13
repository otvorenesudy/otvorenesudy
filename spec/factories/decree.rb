FactoryGirl.define do
  factory :decree_form, aliases: [:form] do
    sequence(:value) { |n| "Decree form #{n}" }
    sequence(:code)  { |n| "Decree form code #{n}" }
  end

  factory :decree do
    uri
    source

    court
    form { create :decree_form }

    date { Time.now }
  end
end
