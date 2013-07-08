class Period < ActiveRecord::Base
  attr_accessible :name, :value

  validates :name,  presence: true
  validates :value, presence: true

  has_many :subscriptions, dependent: :destroy

  def self.for(name)
    find_by_name(name)
  end

  def include?(time)
    ((Time.now - value)..Time.now).cover? time
  end
end
