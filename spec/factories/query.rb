# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :query do
    model 'Hearing'
    value case_number: 'case_number', historical: true
  end
end
