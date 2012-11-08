class Proposer < ActiveRecord::Base
  attr_accessible :name
  
  belongs_to :hearing
             
  validates :name, presence: true
end
