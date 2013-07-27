module Probe
  module Search
    extend ActiveSupport::Concern

    module ClassMethods
      def search(params = {}, &block)
        options = search_options

        options.merge! params: params

        search = Composer.new(self, options)

        search.compose(&block)
      end

      def search_options
        options = Hash.new

        options[:name]        = probe.name
        options[:facets]      = probe.facets
        options[:sort_fields] = probe.sort_fields
        options[:per_page]    = probe.per_page

        options
      end
    end
  end
end
