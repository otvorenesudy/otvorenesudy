class Proposer < ActiveRecord::Base
  attr_accessible :name
  
  has_many :hearings
             
  validates :name, presence: true
end
