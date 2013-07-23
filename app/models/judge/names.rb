module Judge::Names
  extend self
  
  def from(relation)
    from_matched(relation.exact) + from_unprocessed(relation.inexact)
  end
  
  def from_matched(relation)
    relation.map { |r| r.judge.name }
  end
  
  def from_unprocessed(relation)
    relation.inexact.pluck(:judge_name_unprocessed).map { |name|
      Resource::Normalizer.normalize_person_name(name)
    }.uniq
  end
end
