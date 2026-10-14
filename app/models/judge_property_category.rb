# frozen_string_literal: true

class JudgePropertyCategory < ApplicationRecord
  has_many :property_lists, class_name: 'JudgePropertyList',
                            foreign_key: :judge_property_list_id,
                            inverse_of: false,
                            dependent: nil

  validates :value, presence: true
end
