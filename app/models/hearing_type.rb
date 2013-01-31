# encoding: utf-8

class HearingType < ActiveRecord::Base
  include Resource::Enumerable
  
  attr_accessible :value
  
  has_many :hearings
             
  validates :value, presence: true
  
  value :civil,    'Civilné'
  value :criminal, 'Trestné'
  value :special,  'Špecializovaného trestného súdu'  
end
