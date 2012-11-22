class Proceeding < ActiveRecord::Base
  attr_accessible :file_number
  
  has_many :hearings
  has_many :decrees
end
