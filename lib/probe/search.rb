module Probe
  module Search
    extend ActiveSupport::Concern

    module ClassMethods
      def search(params = {})
        options = search_options

        options.merge! params: params

        search = Composer.new(self, options)

        search.compose
      end

      def search_options
        options = Hash.new

        options[:name]        = index_name
        options[:facets]      = Probe::Facets.new(@facet_definitions)
        options[:sort_fields] = sort_fields
        options[:per_page]    = per_page

        options
      end
    end
  end
end
