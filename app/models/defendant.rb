class Defendant < ActiveRecord::Base
  attr_accessible :name,
                  :name_unprocessed

  belongs_to :hearing

  has_many :accusations, dependent: :destroy

  validates :name, presence: true
end
