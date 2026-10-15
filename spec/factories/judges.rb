# frozen_string_literal: true

FactoryBot.define do
  factory :judge do
    uri
    source { Source.of('JusticeGovSk') }
    prefix { 'JUDr.' }
    first { 'Peter' }
    middle { nil }
    sequence(:last) { |n| "Novák#{n}" }
    suffix { nil }
    addition { nil }
    name { [prefix, first, middle, last].compact.join(' ') }
    name_unprocessed { name }

    trait :active do
      after(:create) { |judge| create(:employment, :active, judge:) }
    end

    trait :inactive do
      after(:create) { |judge| create(:employment, :inactive, judge:) }
    end
  end

  factory :employment do
    judge
    court
    active { true }

    trait :active do
      active { true }
    end

    trait :inactive do
      active { false }
    end

    trait :unknown do
      active { nil }
    end
  end

  factory :judge_position do
    sequence(:value) { |n| "pozícia #{n}" }
  end

  factory :judge_designation_type do
    sequence(:value) { |n| "Typ vymenovania #{n}" }
  end

  factory :judge_designation do
    judge
    date { Date.new(2005, 6, 1) }
    source { Source.of('NrsrSk') }
    uri
  end

  factory :judge_property_declaration do
    judge
    court
    year { 2012 }
    source { Source.of('SudnaradaGovSk') }
    uri
  end

  factory :judge_related_person do
    property_declaration factory: %i[judge_property_declaration]
    sequence(:name) { |n| "Mária Nováková #{n}" }
    name_unprocessed { name }
    institution { 'Okresný súd Bratislava I' }
    function { 'sudkyňa' }
  end

  factory :judge_income do
    property_declaration factory: %i[judge_property_declaration]
    description { 'príjmy zo zamestnania' }
    value { 40_000 }
  end

  factory :judge_statistical_summary do
    judge
    court
    year { 2012 }
    source { Source.of('JusticeGovSk') }
    uri
  end
end
