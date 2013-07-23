module Judge::Names
  extend self

  # relation can be both judging / judgements or judges directly

  def from(relation)
    from_matched(relation.exact) + from_unprocessed(relation.inexact)
  end
  
  def from_matched(relation)
    relation = relation.joins(:judge) if relation.column_names.include? 'judge_id'
    
    relation.pluck(:name)
  end
  
  def from_unprocessed(relation)
    relation.pluck(:judge_name_unprocessed).map { |name|
      Resource::Normalizer.normalize_person_name(name)
    }.uniq
  end
  
  alias :of :from
end
