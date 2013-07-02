class DecreePage < ActiveRecord::Base
  include Probe
  extend  Probe::Search::Query

  attr_accessible :number,
                  :text

  belongs_to :decree

  scope :by_number, lambda { order :number }

  validates :number, presence: true
  validates :text,   presence: true

  mapping do
    map     :decree_id
    map     :number
    analyze :text
  end

  def self.search_pages(decree_id, text, options = {})
    search_field = analyzed_field(:text)
    highlights   = {}

    results = search do
      query do
        boolean do
          must { term :decree_id, decree_id }

          must do
            string text,
            default_field: search_field,
            default_operator: :or,
            analyze_wildcard: true
          end
        end
      end

      highlight search_field
    end

    results.each do |result|
      result.highlight[search_field.to_s].each do |highlight|
        highlights[result.number] ||= []
        highlights[result.number] << highlight
      end
    end

    return results, highlights
  end

  def image_entry
    "#{number}.png"
  end

  def image_path
    File.join decree.image_path, image_entry
  end
end
