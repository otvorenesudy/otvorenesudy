# frozen_string_literal: true

module Probe
  # Saved searches that a record matches: `Model.percolator.register(id, params)` stores a search, `record.percolate`
  # returns the ids of the stored searches the record matches.
  module Percolate
    extend ActiveSupport::Concern

    class_methods do
      def percolator
        Probe::Percolator.new(self)
      end
    end

    def percolate
      self.class.percolator.percolate(self)
    end
  end
end
