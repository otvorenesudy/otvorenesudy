# frozen_string_literal: true

class Judge
  module Incomes
    extend ActiveSupport::Concern

    def incomes_by_year
      @incomes_by_year ||= property_declarations.order(year: :desc).filter_map do |declaration|
        [declaration.year, declaration.incomes] if declaration.incomes.any?
      end
    end
  end
end
