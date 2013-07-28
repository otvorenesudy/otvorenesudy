module Probe
  module Percolate
    module Record
      def percolate
        self.class.percolator.percolate(self)
      end
    end

    module Mapper
      attr_reader :percolator

      def percolator
        @percolator ||= Probe::Search::Percolator.new(self, search_options)
      end
    end
  end
end
