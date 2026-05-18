class Subscription < ApplicationRecord

  scope :latest, lambda { order('created_at desc') }

  scope :by_model, lambda { |model| joins(:query).where('queries.model = ?', model.to_s) }
  scope :by_period, lambda { |name| joins(:period).where('periods.name = ?', name) }

  belongs_to :user
  belongs_to :query
  belongs_to :period

  accepts_nested_attributes_for :query

  validates :token, presence: true, uniqueness: true

  before_validation :assign_token, on: :create

  after_save :register
  after_initialize :assign_period

  def results
    return @results if @results

    params = query.value.merge sort: :created_at, order: :desc

    @results = query.model.constantize.search(params).records.find_all { |e, _| period.include? e.created_at }
  end

  def register
    query.model.constantize.subscribe(query.id, query.value)
  end

  def notify
    SubscriptionMailer.results(self).deliver if results.any?
  end

  def query_attributes=(attributes)
    if attributes[:id]
      self.query = ::Query.find(attributes[:id])
    else
      self.query = ::Query.create(attributes)
    end
  end

  protected

  def assign_period
    self.period ||= Period.monthly
  end

  def assign_token
    return if token.present?

    self.token = self.class.generate_unique_token
  end

  def self.generate_unique_token
    loop do
      token = SecureRandom.urlsafe_base64(24)
      break token unless where(token: token).exists?
    end
  end
end
