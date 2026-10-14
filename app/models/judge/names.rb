# frozen_string_literal: true

# The names of the judges on a hearing or decree: the matched judges' names, then the source's names of those that
# matched only approximately, normalized.
class Judge
  module Names
    module_function

    # relation: judges through judgings or judgements (hearing.judges), or the judgings or judgements themselves.
    def of(relation)
      from_matched(relation.exact) + from_unprocessed(relation.inexact)
    end

    def from_matched(relation)
      return relation.pluck(:name) unless relation.column_names.include?('judge_id')

      relation.joins(:judge).pluck('judges.name')
    end

    def from_unprocessed(relation)
      relation.pluck(:judge_name_unprocessed).map { |name| NameNormalizer.person_name(name) }.uniq
    end
  end
end
