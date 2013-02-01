# encoding: utf-8

class JudgePosition < ActiveRecord::Base
  attr_accessible :value
  
  scope :chair,     where('judge_positions.value = ? OR value = ?',    'predseda',    'predsedníčka')
  scope :vicechair, where('judge_positions.value = ? OR value = ?', 'podpredseda', 'podpredsedníčka')

  has_many :employments, dependent: :destroy
  
  has_many :judges, through: :employments

  validates :value, presence: true
end
