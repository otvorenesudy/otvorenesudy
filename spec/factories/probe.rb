FactoryGirl.define do
  factory :source do
    uri  :factory_girl
    name :factory_girl

    before :create do |source|
      source.module = :factory_girl
    end
  end

  factory :employment do
    trait :active do
      active true
    end

    trait :inactive do
      active false
    end

    trait :unknown do
      active nil
    end
  end

  factory :judge do
    name 'JUDr. Peter Retep, PhD.'

    name_unprocessed 'JUDr. Peter Retep'
    prefix           'JUDr.'
    first            'Peter'
    middle           ''
    last             'Retep'
    suffix           'PhD.'
    addition         ''

    uri :factory_girl_judge

    source { create :source }
  end
end
