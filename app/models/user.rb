class User < ActiveRecord::Base
  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me

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
