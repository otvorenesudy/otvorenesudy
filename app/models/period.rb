class Period < ActiveRecord::Base
  attr_accessible :name,
                  :value

  scope :of, lambda { |name| where(name: name) }

  has_many :subscriptions, dependent: :destroy

  validates :name,  presence: true
  validates :value, presence: true

  def include?(time)
    ((Time.now - value) .. Time.now).cover? time
  end
end
