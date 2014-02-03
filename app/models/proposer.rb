class Proposer < ActiveRecord::Base
  attr_accessible :name,
                  :name_unprocessed

  belongs_to :hearing

  validates :name, presence: true
end
