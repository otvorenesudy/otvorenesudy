module Judge::RelatedPersons
  extend ActiveSupport::Concern
  
  def related_persons
    @related_persons ||= property_declarations.order('year desc').select { |declaration| declaration.related_persons.any? }.map do |declaration|
      [declaration.year, declaration.related_persons.order(:name)]
    end
  end
end
