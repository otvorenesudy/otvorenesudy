# frozen_string_literal: true

class JudgeDesignation < ApplicationRecord
  include Resource::URI

  belongs_to :judge, optional: true

  belongs_to :type, class_name: 'JudgeDesignationType',
                    foreign_key: :judge_designation_type_id,
                    inverse_of: false,
                    optional: true

  validates :date, presence: true

  def duration(time = Time.current)
    other = judge.designations.where('date > ?', date).order(:date).first

    return other.date.to_time - date.to_time if other

    time - date.to_time
  end
end
