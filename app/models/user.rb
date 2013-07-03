class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  validates :email, presence: true, uniqueness: true
end
