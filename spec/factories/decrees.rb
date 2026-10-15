# frozen_string_literal: true

FactoryBot.define do
  factory :decree_form do
    sequence(:value) { |n| "Forma rozhodnutia #{n}" }
    sequence(:code) { |n| ('A'..'Z').to_a[n % 26] }
  end

  factory :decree_nature do
    sequence(:value) { |n| "Povaha #{n}" }
  end

  factory :legislation_area do
    sequence(:value) { |n| "Oblasť #{n}" }
  end

  factory :legislation_subarea do
    sequence(:value) { |n| "Podoblasť #{n}" }
  end

  factory :legislation do
    sequence(:value) { |n| "Zákon #{n}/2005 Z.z." }
    value_unprocessed { value }
    sequence(:number, &:to_s)
    year { 2005 }
  end

  factory :decree do
    uri
    source { Source.of('JusticeGovSk') }
    court
    form { DecreeForm.find_by!(value: 'Rozsudok') }
    date { Date.new(2026, 3, 4) }
    sequence(:ecli) { |n| "ECLI:SK:OSBA1:2026:#{n}" }
    sequence(:case_number) { |n| "#{n}C/2/2026" }
    sequence(:file_number) { |n| (3_000_000 + n).to_s }
    pdf_uri { "https://obcan.justice.sk/decree/#{ecli}.pdf" }

    trait :with_text do
      transient do
        text { 'Okresný súd rozhodol v mene Slovenskej republiky.' }
      end

      after(:create) { |decree, context| create(:decree_page, decree:, text: context.text) }
    end
  end

  factory :decree_page do
    decree
    sequence(:number) { |n| n }
    text { 'Text strany.' }
  end

  factory :judgement do
    decree
    judge
    judge_name_similarity { 1.0 }
    judge_name_unprocessed { judge.name }
  end
end
