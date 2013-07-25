module Judge::RelatedPeople
  extend ActiveSupport::Concern

  module ClassMethods
    def at_least_one_related_person_rate
      @at_least_one_related_person_rate ||= Judge.joins(:related_people).group('judge_property_declarations.judge_id').count.size / JudgePropertyDeclaration.group(:judge_id).count.size.to_f
    end

    def with_most_related_people
      @with_most_related_people ||= where(id: find_all_with_most_related_people.map(&:id))
    end

    private

    def find_all_with_most_related_people
      max    = 0
      judges = Array.new

      with_related_people.find_each do |judge|
        count = judge.related_people.group(:name).count.size

        if count >= max
          judges = Array.new if count > max

          max = count

          judges << judge unless judges.include? judge
        end
      end

      judges
    end
  end

  def related_people_by_year
    @related_people ||= property_declarations.order('year desc').select { |declaration| declaration.related_people.any? }.map do |declaration|
      [declaration.year, declaration.related_people.order(:name)]
    end
  end
end
