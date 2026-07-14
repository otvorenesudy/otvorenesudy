class Defendant < ApplicationRecord

  belongs_to :hearing

  has_many :accusations, dependent: :destroy

  validates :name, presence: true
end
