require 'digest/sha1'

class Query < ActiveRecord::Base
  attr_accessible :model, :digest, :value

  validates :digest, presence: true
  validates :value,  presence: true
  validates :model,  presence: true, inclusion: { in: %w(Decree Hearing) }

  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions

  before_validation :create_digest

  alias :subscribers :users

  def value
    attribute = read_attribute(:value)

    JSON.parse(attribute) if attribute
  end

  def value=(value)
    write_attribute(:value, parse_value(value))
  end


  def self.to_digest(value)
    Digest::SHA1.hexdigest(parse_value(value))
  end

  def self.by_digest_and_model(query, model)
    find_by_digest_and_model(to_digest(query), model.to_s)
  end

  private

  def create_digest
    self.digest ||= self.class.to_digest(parse_value(self.value))
  end

  def self.parse_value(hash)
    hash.is_a?(String) ? hash : hash.to_json
  end

  def parse_value(hash)
    self.class.parse_value(hash)
  end
end
