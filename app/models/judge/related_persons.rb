module Judge::RelatedPersons
  extend ActiveSupport::Concern
  
  module ClassMethods
    def at_least_one_related_person_rate
      @at_least_one_related_person_rate ||= Judge.joins(:related_persons).group('judge_property_declarations.judge_id').count.size / JudgePropertyDeclaration.group(:judge_id).count.size.to_f
    end

    def with_most_related_persons
      find by_related_persons.count.first[0]
    end
  end
  
  def related_persons_by_year
    @related_persons ||= property_declarations.order('year desc').select { |declaration| declaration.related_persons.any? }.map do |declaration|
      [declaration.year, declaration.related_persons.order(:name)]
    end
  end
end
