# frozen_string_literal: true

class Defendant < ApplicationRecord
  belongs_to :hearing, optional: true

  has_many :accusations, dependent: :destroy

  validates :name, presence: true
end
