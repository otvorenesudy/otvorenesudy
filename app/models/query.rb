require 'digest/sha1'

class Query < ActiveRecord::Base
  attr_accessible :model,
                  :digest,
                  :value

  scope :by_model_and_value, lambda { |model, value| where(digest: ::Query.digest(value), model: model.to_s) }

  has_many :subscriptions, dependent: :destroy

  has_many :users, through: :subscriptions

  alias :subscribers :users

  before_validation :compute_digest

  validates :digest, presence: true
  #validates :value,  presence: true # TODO ??
  validates :model,  presence: true, inclusion: { in: %w(Decree Hearing) }

  def value
    JSON.parse(read_attribute(:value), symbolize_names: true)
  end

  def value=(value)
    write_attribute(:value, ::Query.wrap(value))
  end

  def self.digest(value)
    Digest::SHA1.hexdigest wrap(value)
  end

  def self.wrap(value)
    value = JSON.parse(value, symbolize_names: true) if value.is_a? String

    value.except(:page, :per_page, :order, :sort).to_json
  end

  def wrap(value)
    self.class.wrap(value)
  end

  private

  def compute_digest
    self.digest ||= ::Query.digest(::Query.wrap(value))
  end
end
