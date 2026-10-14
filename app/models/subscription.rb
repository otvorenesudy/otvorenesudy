# frozen_string_literal: true

# A user's saved search with the period of its e-mail of new results.
class Subscription < ApplicationRecord
  scope :latest, -> { order(created_at: :desc) }
  scope :by_model, ->(model) { joins(:query).where(queries: { model: model.to_s }) }
  scope :by_period, ->(name) { joins(:period).where(periods: { name: }) }

  belongs_to :user
  belongs_to :query
  belongs_to :period

  accepts_nested_attributes_for :query

  validates :token, presence: true, uniqueness: true

  after_initialize :assign_period
  before_validation :assign_token, on: :create
  after_save :register

  def self.generate_unique_token
    loop do
      token = SecureRandom.urlsafe_base64(24)

      break token unless exists?(token:)
    end
  end

  # The records of the first page of the saved search, newest first, created within the period.
  def results
    @results ||= begin
      params = query.value.merge(sort: :created_at, order: :desc)

      query.model.constantize.search(params).records.select { |record| period.include?(record.created_at) }
    end
  end

  def register
    query.model.constantize.subscribe(query.id, query.value)
  end

  def notify
    SubscriptionMailer.results(self).deliver_now if results.any?
  end

  # A search already saved is reused by its id; a new one is saved from its model and params.
  def query_attributes=(attributes)
    self.query = attributes[:id] ? Query.find(attributes[:id]) : Query.create(attributes)
  end

  private

  def assign_period
    self.period ||= Period.monthly if has_attribute?(:period_id)
  end

  def assign_token
    self.token = self.class.generate_unique_token if token.blank?
  end
end
