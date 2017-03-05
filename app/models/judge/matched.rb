module Judge::Matched
  extend ActiveSupport::Concern

  included do
    scope :exact,   where(exact_conditions)
    scope :inexact, where(inexact_conditions)
  end

  module ClassMethods
    # TODO consider removing this when moving to Rails >= 4 which supports scopes in has_many associations
    def exact_conditions
      'judge_name_similarity = 1.0'
    end

    def inexact_conditions
      'judge_name_similarity < 1.0'
    end
  end
end
