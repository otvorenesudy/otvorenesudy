# frozen_string_literal: true

# How often a subscription sends its e-mail; value is the period's length in seconds.
class Period < ApplicationRecord
  include Resource::Enumerable

  scope :of, ->(name) { where(name:) }

  has_many :subscriptions, dependent: :destroy

  validates :name, presence: true
  validates :value, presence: true

  value :daily, 1.day.to_i
  value :weekly, 1.week.to_i
  value :monthly, 1.month.to_i

  def include?(time)
    ((Time.current - value)..Time.current).cover?(time)
  end
end
