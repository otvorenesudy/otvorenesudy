FactoryGirl.define do
  factory :query do
    model 'Decree'

    trait :empty do
      value Hash.new
    end

    trait :for_hearing do
      model 'Hearing'

      value q: 'Hearing', date: 2.years.ago.to_date.to_s..1.year.from_now.to_date.to_s, historical: true
    end

    trait :for_decree do
      model 'Decree'

      value q: 'Decree', date: 2.years.ago.to_date.to_s..1.year.from_now.to_date.to_s
    end
  end
end
