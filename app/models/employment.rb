# encoding: utf-8

class Employment < ActiveRecord::Base
  attr_accessible :active,
                  :note
  
  scope :active,   where('employments.active = true')
  scope :inactive, where('employments.active = false')
  
  scope :at_court, lambda { |court| where court_id: court }
  
  belongs_to :court
  belongs_to :judge
  belongs_to :judge_position
end
