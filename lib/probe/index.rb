module Probe
  class Index
    include Probe::Helpers
    include Probe::Index::Alias
    include Probe::Index::Configuration
    include Probe::Index::Creation
    include Probe::Index::Facets
    include Probe::Index::Mapping
    include Probe::Index::Pagination
    include Probe::Index::Sort

    attr_reader :base, :type

    def initialize(base)
      @base = base
      @type = @base.respond_to?(:table_name) ? @base.table_name : @base.to_s.underscore

      @type = @type.to_sym
    end

    def search(params = {}, &block)
      search = Search::Composer.new(self, params)

      search.compose(&block)
    end

    def percolator
      @percolator ||= Search::Percolator.new(self, search_options)
    end

    def percolate(record)
      percolator.percolate(record)
    end

    def suggest(name, term, params, options = {})
      @suggester ||= Search::Suggester.new(self)

      @suggester.suggest(name, term, params, options)
    end

    def index(index = nil)
      index ? Tire::Index.new(index) : @index ||= Tire::Index.new(name)
    end
  end
end
