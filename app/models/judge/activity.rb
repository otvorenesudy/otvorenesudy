# frozen_string_literal: true

# Judges by whether their employment (joined) is active.
class Judge
  module Activity
    extend ActiveSupport::Concern

    included do
      scope :active, -> { where(employments: { active: true }) }
      scope :inactive, -> { where(employments: { active: false }) }
      scope :unknown, -> { where(employments: { active: nil }) }

      scope :not_active, -> { where(employments: { active: [false, nil] }) }
      scope :not_inactive, -> { where(employments: { active: [true, nil] }) }
      scope :not_unknown, -> { where.not(employments: { active: nil }) }
    end
  end
end
