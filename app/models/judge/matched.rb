module Judge::Matched
  extend ActiveSupport::Concern

  included do
    scope :exact,   where('judge_name_similarity = 1.0')
    scope :inexact, where('judge_name_similarity < 1.0')
  end

  module ClassMethods
    # TODO consider removing this when moving to Rails >= 4
    # which supports scopes in has_many associations
    def exact_conditions
      'judge_name_similarity = 1.0'
    end

    def inexact_conditions
      'judge_name_similarity < 1.0'
    end
  end
end
