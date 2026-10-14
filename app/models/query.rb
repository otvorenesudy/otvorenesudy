# frozen_string_literal: true

require 'digest/sha1'

# A saved search: a listing's facet params, stored as JSON with a digest so the same search is stored once per model.
class Query < ApplicationRecord
  include Resource::Serializable

  MODELS = %w[Decree Hearing].freeze

  scope :by_model, ->(model) { where(model: model.to_s) }
  scope :by_model_and_value, ->(model, value) { where(digest: Query.digest(value), model: model.to_s) }

  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions

  alias subscribers users

  before_validation :compute_digest

  validates :digest, presence: true
  validates :model, presence: true, inclusion: { in: MODELS }

  def self.digest(value)
    Digest::SHA1.hexdigest(unwrap(value))
  end

  def self.wrap(value)
    value.is_a?(String) ? JSON.parse(value, symbolize_names: true) : value
  end

  def self.unwrap(value)
    value.is_a?(String) ? value : serialize_as_json(value)
  end

  def value
    JSON.parse(self[:value], symbolize_names: true)
  end

  def value=(value)
    self[:value] = Query.unwrap(value)
  end

  private

  def compute_digest
    self.digest ||= Query.digest(Query.wrap(self[:value]))
  end
end
