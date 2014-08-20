FactoryGirl.define do
  factory :decree_form, aliases: [:form] do
    sequence(:value) { |n| "Decree form #{n}" }
    sequence(:code)  { |n| "Decree form code #{n}" }
  end

  factory :judgement do
    judge_name_similarity  1.0
    judge_name_unprocessed 'unprocessed'

    judge
  end

  factory :decree do
    uri
    source

    sequence(:ecli)        { |n| "ECLI #{n}" }
    sequence(:file_number) { |n| "File Number #{n}" }
    sequence(:case_number) { |n| "Case Number #{n}" }

    association :court

    form { create :decree_form }
    date { Time.now }

    after :create do |decree|
      3.times.map { create :judgement, decree: decree }
    end
  end
end
