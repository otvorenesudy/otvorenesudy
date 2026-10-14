# frozen_string_literal: true

FactoryBot.define do
  sequence(:uri) { |n| "https://www.justice.gov.sk/factory/#{n}" }

  factory :source do
    uri
    sequence(:name) { |n| "Source #{n}" }
    sequence(:module) { |n| "FactorySource#{n}" }
  end

  factory :municipality do
    sequence(:name) { |n| "Obec #{n}" }
    zipcode { '811 01' }
  end

  factory :court do
    uri
    source { Source.of('JusticeGovSk') }
    sequence(:name) { |n| "Okresný súd #{n}" }
    street { 'Námestie 1' }
    municipality
    type { CourtType.district }

    trait :regional do
      type { CourtType.regional }
    end

    trait :supreme do
      type { CourtType.supreme }
    end
  end

  factory :court_office_type do
    sequence(:value) { |n| "Typ pracoviska #{n}" }
  end

  factory :court_office do
    court
    type { CourtOfficeType.information_center }
  end

  factory :court_expense do
    court
    source { Source.of('JusticeGovSk') }
    uri
    year { 2012 }
    value { 10_000 }
  end
end
