# encoding: utf-8

class Employment < ActiveRecord::Base
  attr_accessible :active,
                  :note
  
  belongs_to :court
  belongs_to :judge
  belongs_to :judge_position
end
