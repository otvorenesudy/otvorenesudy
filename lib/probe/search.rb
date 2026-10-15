# frozen_string_literal: true

module Probe
  # `Model.search(params)`: a listing's URL params (facets, `page`, `sort`, `order`) in, Probe::Search::Results out.
  module Search
    extend ActiveSupport::Concern

    class_methods do
      def search(params = {})
        Probe::Search::Composer.new(self, params).compose
      end
    end
  end
end
