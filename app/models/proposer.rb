class Proposer < ApplicationRecord

  belongs_to :hearing

  validates :name, presence: true
end
