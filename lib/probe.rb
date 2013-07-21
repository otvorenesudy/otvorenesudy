require 'probe/converters/date'
require 'probe/converters/numeric'
require 'probe/facets/facet'
require 'probe/facets/terms_facet'
require 'probe/facets/range_facet'
require 'probe/facets/date_facet'
require 'probe/facets/fulltext_facet'
require 'probe/facets/boolean_facet'
require 'probe/facets/multi_terms_facet'
require 'probe/helpers/index'
require 'probe/search/filter'
require 'probe/search/query'
require 'probe/search/results'
require 'probe/search/composer'
require 'probe/configuration'
require 'probe/index'
require 'probe/facets'
require 'probe/search'
require 'probe/serialize'
require 'probe/suggest'
require 'probe/bulk'

module Probe
  extend ActiveSupport::Concern

  included do
    include Probe::Index
    include Probe::Search
    include Probe::Suggest
    include Probe::Percolate

    include Tire::Model::Search

    setup
  end
end
