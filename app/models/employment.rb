class Employment < ActiveRecord::Base
  attr_accessible :active,
                  :status,
                  :note

  include Judge::Activity

  scope :at_court,         lambda { |court| where(court_id: court) }
  scope :at_court_by_type, lambda { |type| joins(:court).merge(Court.by_type type) }

  belongs_to :court
  belongs_to :judge
  belongs_to :judge_position
end
