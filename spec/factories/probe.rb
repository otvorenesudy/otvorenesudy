class Record < Struct.new(:id, :number, :title, :text); end

FactoryGirl.define do
  factory :record do
    sequence(:id)     { |n| n }
    sequence(:number) { |n| n * 2 }
    sequence(:title)  { |n| "Title #{n}" }
    sequence(:text)   { |n| "Text #{n}"  }
  end
end
