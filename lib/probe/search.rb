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

        options[:name]        = probe.index.name
        options[:facets]      = probe.facets
        options[:sort_fields] = probe.sort_fields
        options[:per_page]    = probe.per_page

        options
      end
    end
  end
end
