module Probe
  module Search
    module Mapper
      def search(params = {}, &block)
        search = Composer.new(self.probe, params)

        search.compose(&block)
      end

      def total
        search { match_all }.total
      end
    end
  end
end
