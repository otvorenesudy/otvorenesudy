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
  #validates :value,  presence: true
  validates :model,  presence: true, inclusion: { in: %w(Decree Hearing) }

  def value
    JSON.parse(read_attribute(:value))
  end

  def value=(value)
    write_attribute(:value, wrap(value))
  end

  def self.digest(value)
    Digest::SHA1.hexdigest wrap(value)
  end

  def self.wrap(value)
    value.is_a?(String) ? value : value.to_json
  end

  def wrap(value)
    self.class.wrap(value)
  end

  private

  def compute_digest
    self.digest ||= ::Query.digest wrap(value)
  end
end
