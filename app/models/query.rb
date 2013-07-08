require 'digest/sha1'

class Query < ActiveRecord::Base
  attr_accessible :model,
                  :digest,
                  :value

  scope :by_model_and_value, lambda { |model, value| where(digest: digest(query), model: model.to_s) }

  has_many :subscriptions, dependent: :destroy

  has_many :users, through: :subscriptions

  alias :subscribers :users

  before_validation :create_digest

  validates :digest, presence: true
  validates :value,  presence: true
  validates :model,  presence: true, inclusion: { in: %w(Decree Hearing) }

  def value
    attribute = read_attribute(:value)

    JSON.parse(attribute) if attribute
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
  
  private

  def create_digest
    self.digest ||= self.class.digest wrap(self.value)
  end
end
