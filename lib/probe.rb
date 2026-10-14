# frozen_string_literal: true

# Search on Elasticsearch for the models that include it. A model declares how its records are indexed (`mapping`) and
# which facets its listing offers (`facets`); Probe creates and fills the index, keeps it in step with the database and
# turns a listing's URL params into a search with aggregations:
#
#   class Court < ApplicationRecord
#     include Probe
#
#     mapping do
#       map :id
#       analyze :name
#       analyze :judges_count, type: :integer, as: ->(court) { court.judges.count }
#       sort_by :name, :_score
#     end
#
#     facets do
#       facet :q, type: :fulltext, field: %i[name]
#       facet :judges_count, type: :range, ranges: [5..10, 10..20]
#     end
#   end
#
#   Court.search(q: 'košice', judges_count: ['5..9']) # => Probe::Search::Results
module Probe
  extend ActiveSupport::Concern

  included do
    include Probe::Index
    include Probe::Serialize
    include Probe::Search
    include Probe::Suggest
    include Probe::Percolate
  end

  def self.client
    @client ||= Elasticsearch::Client.new(Probe::Configuration.client)
  end

  def self.models
    Probe::Configuration.indices.map { |index| index.singularize.camelize.constantize }
  end
end
