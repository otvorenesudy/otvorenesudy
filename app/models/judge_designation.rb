class JudgeDesignation < ActiveRecord::Base
  include Resource::URI

  attr_accessible :date

  belongs_to :judge

  belongs_to :type, class_name: :JudgeDesignationType, foreign_key: :judge_designation_type_id

  validates :date, presence: true

  def duration(time = Time.now)
    other = judge.designations.where('date > ?', date).order(:date).first

    return other.date.to_time - date.to_time if other

    time - date.to_time
  end
end
