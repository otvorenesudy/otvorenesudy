FactoryGirl.define do
  factory :hearing_type do
    sequence(:value) { |n| "Hearing Type #{n}" }
  end

  factory :judging do
    judge_chair            false
    judge_name_similarity  1.0
    judge_name_unprocessed 'unprocessed'

    judge
  end

  factory :hearing do
    uri
    source

    court

    date { Time.now }

    sequence(:case_number) { |n| "Case Number #{n}" }
    sequence(:file_number) { |n| "File Number #{n}" }

    type { create :hearing_type }

    after :create do |hearing|
      3.times.map { create :judging, hearing: hearing }
    end
  end
end
