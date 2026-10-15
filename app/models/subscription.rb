# frozen_string_literal: true

# A user's saved search with the period of its e-mail of new results.
class Subscription < ApplicationRecord
  scope :latest, -> { order(created_at: :desc) }
  scope :by_model, ->(model) { joins(:query).where(queries: { model: model.to_s }) }
  scope :by_period, ->(name) { joins(:period).where(periods: { name: }) }
  scope :of_confirmed_users, -> { joins(:user).where.not(users: { confirmed_at: nil }) }

  belongs_to :user
  belongs_to :query
  belongs_to :period

  accepts_nested_attributes_for :query

  validates :token, presence: true, uniqueness: true
  validates :query_id, uniqueness: { scope: %i[user_id period_id] }

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

  # The same search (its model and params) is saved once and shared by its subscriptions. Within the class, Query is
  # Active Record's AttributeMethods::Query, hence ::Query.
  def query_attributes=(attributes)
    model, value = attributes.to_h.symbolize_keys.values_at(:model, :value)
    value = ::Query.wrap(value.presence || {})

    self.query = ::Query.by_model_and_value(model, value).first || ::Query.new(model:, value:)
  end

  private

  def assign_period
    self.period ||= Period.monthly if has_attribute?(:period_id)
  end

  def assign_token
    self.token = self.class.generate_unique_token if token.blank?
  end
end
