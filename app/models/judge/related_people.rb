# frozen_string_literal: true

# People related to a judge, from the judge's property declarations.
class Judge
  module RelatedPeople
    extend ActiveSupport::Concern

    included do
      scope :with_related_people, -> { joins(:related_people) }
    end

    class_methods do
      def at_least_one_related_person_rate
        with_people = Judge.joins(:related_people).distinct.count('judge_property_declarations.judge_id')

        with_people / JudgePropertyDeclaration.distinct.count(:judge_id).to_f
      end

      def with_most_related_people
        counts = with_related_people.group('judges.id').count('DISTINCT judge_related_people.name')
        most = counts.values.max

        where(id: counts.select { |_, count| count == most }.keys)
      end
    end

    def related_people_by_year
      @related_people_by_year ||= property_declarations.order(year: :desc).filter_map do |declaration|
        people = declaration.related_people.order(:name)

        [declaration.year, people] if people.any?
      end
    end
  end
end
