# encoding: utf-8

class JudgePosition < ActiveRecord::Base
  attr_accessible :value

  scope :chair,     where('judge_positions.value = ? OR value = ?',    'predseda',    'predsedníčka')
  scope :vicechair, where('judge_positions.value = ? OR value = ?', 'podpredseda', 'podpredsedníčka')

  has_many :employments, dependent: :destroy

  has_many :judges, through: :employments

  validates :value, presence: true

  def charged
    @charged ||= value.utf8 =~ /\Apoveren[ýá]/i
  end

  alias :charged? :charged
end
