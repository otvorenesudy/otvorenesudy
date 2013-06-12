module Probe
  module Search
    extend ActiveSupport::Concern

    module ClassMethods

      def search_by(params = {})
        options = Hash.new

        options[:name]        = self.index.name
        options[:params]      = params
        options[:facets]      = @facets
        options[:sort_fields] = @sort_fields

        search = Composer.new(self, options)

        search.compose
      end
    end
  end
end
