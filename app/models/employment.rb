# encoding: utf-8

class Employment < ActiveRecord::Base
  attr_accessible :active,
                  :note
  
  scope :active,   where('employments.active = true')
  scope :inactive, where('employments.active = false')
  scope :unknown,  where('employments.active IS NULL')
  
  scope :at_court,         lambda { |court| where(court_id: court) }
  scope :at_court_by_type, lambda { |type| joins(:court).merge(Court.by_type type) }
  
  belongs_to :court
  belongs_to :judge
  belongs_to :judge_position
end
