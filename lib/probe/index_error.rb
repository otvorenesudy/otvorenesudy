# frozen_string_literal: true

module Probe
  # Elasticsearch rejected a document in a bulk request.
  class IndexError < StandardError; end
end
