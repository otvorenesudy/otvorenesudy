module Judge::Activity
  extend ActiveSupport::Concern

  included do
    scope :active,   where('employments.active = true')
    scope :inactive, where('employments.active = false')
    scope :unknown,  where('employments.active IS NULL')

    scope :not_active,   where('employments.active = false OR employments.active IS NULL')
    scope :not_inactive, where('employments.active = true  OR employments.active IS NULL')
    scope :not_unknown,  where('employments.active IS NOT NULL')
  end
end
