module Probe
  module Percolate
    extend ActiveSupport::Concern

    def percolate
      self.class.percolator.percolate(self)
    end

    module ClassMethods
      attr_reader :percolator

      def percolator
        @percolator ||= Probe::Search::Percolator.new(self, search_options)
      end
    end
  end
end
