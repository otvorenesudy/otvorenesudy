# encoding: utf-8

class HearingType < ActiveRecord::Base
  attr_accessible :value
  
  has_many :hearings
             
  validates :value, presence: true
  
  def self.civil
    @@civil ||= find_or_create_by_value 'Civilné'
  end
  
  def self.criminal
    @@criminal ||= find_or_create_by_value 'Trestné'
  end
  
  def self.special
    @@special ||= find_or_create_by_value 'Špecializovaného trestného súdu'
  end
end
