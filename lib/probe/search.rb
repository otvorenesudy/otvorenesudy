module Probe
  module Search
    extend ActiveSupport::Concern

    module ClassMethods
      def search_by(params = {})
        options = Hash.new

        options[:name]             = self.index.name
        options[:params]           = params
        options[:facets]           = @facets
        options[:sort_fields]      = @sort_fields
        options[:highlight_fields] = @highlight_fields
        options[:per_page]         = @_default_per_page

        search = Composer.new(self, options)

        search.compose
      end
    end
  end
end
