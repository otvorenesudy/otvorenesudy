FactoryGirl.define do
  sequence(:uri)    { |n| "factory_girl_uri_#{n}" }

  factory :source do
    uri
    sequence(:name)   { |n| "factory_girl_name_#{n}" }
    sequence(:module) { |n| "factory_girl_module_#{n}" }
  end
end


