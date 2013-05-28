class DecreePage < ActiveRecord::Base
  attr_accessible :number,
                  :text

  belongs_to :decree

  scope :by_number, lambda { order :number }

  def image_entry
    "#{number}.png"
  end

  def image_path
    File.join decree.image_path, image_entry
  end

  validates :number, presence: true
  validates :text,   presence: true
end
