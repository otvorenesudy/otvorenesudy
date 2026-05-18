class User < ApplicationRecord

  devise :confirmable,
         :database_authenticatable,
         :recoverable,
         :registerable,
         :rememberable,
         :validatable

  has_many :subscriptions, dependent: :destroy
  has_many :queries, through: :subscriptions

  validates :email, presence: true, uniqueness: true
end
