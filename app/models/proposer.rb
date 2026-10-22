# frozen_string_literal: true

class Proposer < ApplicationRecord
  belongs_to :hearing, optional: true

  validates :name, presence: true
end
