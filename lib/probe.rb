require 'probe/sanitizer'
require 'probe/converters/date'
require 'probe/converters/numeric'
require 'probe/facets/facet'
require 'probe/facets/terms_facet'
require 'probe/facets/range_facet'
require 'probe/facets/date_facet'
require 'probe/facets/fulltext_facet'
require 'probe/facets/boolean_facet'
require 'probe/index/alias'
require 'probe/index/configuration'
require 'probe/index/facets'
require 'probe/index/mapping'
require 'probe/index/pagination'
require 'probe/index/sort'
require 'probe/search/filter'
require 'probe/search/query'
require 'probe/search/results'
require 'probe/search/composer'
require 'probe/configuration'
require 'probe/helpers'
require 'probe/index'
require 'probe/record'
require 'probe/facets'

module Probe
  extend ActiveSupport::Concern

  included do
    include Probe::Proxy
  end

  def self.config(&block)
    block.call(Probe::Configuration) if block_given?

    Probe::Configuration
  end
end
