class JudgePosition < ActiveRecord::Base
  attr_accessible :value

  scope :chair, where('judge_positions.value = ? OR value = ?', 'predseda', 'predsedníčka')
  scope :vicechair, where('judge_positions.value = ? OR value = ?', 'podpredseda', 'podpredsedníčka')
  scope :judicial_council_chair,
        where('judge_positions.value = ? OR value = ?', 'predseda súdnej rady', 'predsedníčka súdnej rady')
  scope :judicial_council_member,
        where('judge_positions.value = ? OR value = ?', 'člen súdnej rady', 'členka súdnej rady')

  has_many :employments, dependent: :destroy

  has_many :judges, through: :employments

  validates :value, presence: true

  def charged
    @charged ||= value.utf8 =~ /\Apoveren[ýá]/i
  end

  alias charged? charged
end
