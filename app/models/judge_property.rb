# frozen_string_literal: true

class JudgeProperty < ApplicationRecord
  belongs_to :list, class_name: 'JudgePropertyList',
                    foreign_key: :judge_property_list_id,
                    inverse_of: false,
                    optional: true

  belongs_to :acquisition_reason, class_name: 'JudgePropertyAcquisitionReason',
                                  foreign_key: :judge_property_acquisition_reason_id,
                                  inverse_of: false,
                                  optional: true

  belongs_to :ownership_form, class_name: 'JudgePropertyOwnershipForm',
                              foreign_key: :judge_property_ownership_form_id,
                              inverse_of: false,
                              optional: true

  belongs_to :change, class_name: 'JudgePropertyChange',
                      foreign_key: :judge_property_change_id,
                      inverse_of: false,
                      optional: true
end
