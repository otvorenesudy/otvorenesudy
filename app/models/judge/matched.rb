module Judge::Matched
  extend ActiveSupport::Concern

  included do
    scope :exact,   where('judge_name_similarity = 1.0')
    scope :inexact, where('judge_name_similarity < 1.0')
  end
end
