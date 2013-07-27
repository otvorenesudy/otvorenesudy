class Record < Struct.new(:id, :number, :title, :text)
  class << self
    attr_accessor :collection

    include Enumerable

    def each
      collection.each { |e| yield e }
    end

    def paginate(options = {})
      options[:page] -= 1

      collection[(options[:page] * options[:per_page])..options[:per_page]]
    end
  end
end

FactoryGirl.define do
  factory :record do
    sequence(:id)     { |n| n }
    sequence(:number) { |n| n * 2 }
    sequence(:title)  { |n| "Title #{n}" }
    sequence(:text)   { |n| "Text #{n}"  }
  end
end
