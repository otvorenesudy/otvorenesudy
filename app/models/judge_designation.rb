class JudgeDesignation < ActiveRecord::Base
  include Resource::URI

  attr_accessible :date

  belongs_to :judge

  belongs_to :type, class_name: :JudgeDesignationType, foreign_key: :judge_designation_type_id

  validates :date, presence: true

  def duration
    another = judge.designations.where('date > ?', date).first

    return another.date.to_time - date.to_time if another

    Time.now - date.to_time
  end
end
