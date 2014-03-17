class JudgeDesignation < ActiveRecord::Base
  include Resource::URI

  attr_accessible :date

  belongs_to :judge

  belongs_to :type, class_name: :JudgeDesignationType, foreign_key: :judge_designation_type_id

  validates :date, presence: true

  def duration
    another = judge.designations.where('date > ?', date).first

    return another.date - date if another

    (Date.today - date).to_i
  end
end
