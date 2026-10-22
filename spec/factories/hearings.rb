# frozen_string_literal: true

FactoryBot.define do
  factory :proceeding do
    sequence(:file_number) { |n| (1_000_000 + n).to_s }
  end

  factory :hearing_section do
    sequence(:value) { |n| "Úsek #{n}" }
  end

  factory :hearing_subject do
    sequence(:value) { |n| "Predmet #{n}" }
  end

  factory :hearing_form do
    sequence(:value) { |n| "Forma #{n}" }
  end

  factory :hearing do
    uri
    source { Source.of('JusticeGovSk') }
    court
    type { HearingType.civil }
    date { 1.month.from_now.change(hour: 9) }
    sequence(:case_number) { |n| "#{n}C/1/2026" }
    sequence(:file_number) { |n| (2_000_000 + n).to_s }
    anonymized_at { Time.current }

    trait :criminal do
      type { HearingType.criminal }
    end

    trait :past do
      date { 1.month.ago.change(hour: 9) }
    end
  end

  factory :judging do
    hearing
    judge
    judge_name_similarity { 1.0 }
    judge_name_unprocessed { judge.name }
    judge_chair { false }
  end

  factory :proposer do
    hearing
    name { 'J. N.' }
    name_unprocessed { name }
  end

  factory :opponent do
    hearing
    name { 'M. K.' }
    name_unprocessed { name }
  end

  factory :defendant do
    hearing
    name { 'P. S.' }
    name_unprocessed { name }
  end
end
