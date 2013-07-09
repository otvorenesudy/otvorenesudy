class User < ActiveRecord::Base
  devise :confirmable,
         :database_authenticatable,
         :recoverable,
         :registerable,
         :rememberable,
         :validatable

  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me

  validates :email, presence: true, uniqueness: true

  has_many :subscriptions
  has_many :queries, through: :subscriptions
end
