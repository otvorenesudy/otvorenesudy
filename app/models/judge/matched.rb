# frozen_string_literal: true

# Whether the judge name in the source matched a judge exactly, or only approximately. The column is on judgings and
# judgements, so on judges, hearings and decrees these scopes work through a join with them (hearing.judges.exact).
class Judge
  module Matched
    extend ActiveSupport::Concern

    included do
      scope :exact, -> { where('judge_name_similarity = 1.0') }
      scope :inexact, -> { where('judge_name_similarity < 1.0') }
    end
  end
end
