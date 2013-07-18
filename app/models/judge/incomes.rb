module Judge::Incomes
  extend ActiveSupport::Concern
  
  def incomes
    @incomes ||= property_declarations.order('year desc').select { |declaration| declaration.incomes.any? }.map do |declaration|
      [declaration.year, declaration.incomes]
    end
  end
end
