class Proceeding < ActiveRecord::Base
  has_many :hearings
  has_many :decrees
end
