class Period < ActiveRecord::Base
  include Resource::Enumerable

  attr_accessible :name,
                  :value

  scope :of, lambda { |name| where(name: name) }

  has_many :subscriptions, dependent: :destroy

  validates :name,  presence: true
  validates :value, presence: true

  value :daily,   1.day.to_i
  value :weekly,  1.week.to_i
  value :monthly, 1.month.to_i

  def include?(time)
    ((Time.now - value) .. Time.now).cover? time
  end
end
