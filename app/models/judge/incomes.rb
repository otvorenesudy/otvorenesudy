module Judge::Incomes
  extend ActiveSupport::Concern
  
  def incomes_by_year
    @incomes ||= property_declarations.order('year desc').select { |declaration| declaration.incomes.any? }.map do |declaration|
      [declaration.year, declaration.incomes]
    end
  end
end
