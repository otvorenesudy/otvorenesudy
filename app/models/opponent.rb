# frozen_string_literal: true

class Opponent < ApplicationRecord
  belongs_to :hearing, optional: true

  validates :name, presence: true
end
