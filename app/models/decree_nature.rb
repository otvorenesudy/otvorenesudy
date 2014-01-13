class DecreeNature < ActiveRecord::Base
  attr_accessible :value

  has_many :naturalizations, class_name: :DecreeNaturalization, dependent: :destroy

  has_many :decrees, through: :naturalizations

  validates :value, presence: true
end
