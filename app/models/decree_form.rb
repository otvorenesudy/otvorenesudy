class DecreeForm < ApplicationRecord

  has_many :decrees

  validates :value, presence: true
  validates :code,  presence: true
end
