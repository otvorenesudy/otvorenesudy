class Probe::Facets
  class TermsFacet < Probe::Facets::Facet
    include Probe::Search::Query

    attr_accessor :query,
                  :script

    def build(name, options)
      options = prepare_build(options)

      options.merge! terms: {
        field: untouched_field,
        size: size
      }

      yield options[:terms] if block_given?

      { name => options }
    end

    def build_suggest_facet(index, options)
      build(index, name, options) do |f, facet_options|
        facet_options.merge! script.build if script
      end
    end

    def build_filter
      filter = terms.map do |value|
        if value == missing_facet_name
          { missing: { field: untouched_field, existence: true }}
        else
          { term: { untouched_field => value }}
        end
      end

      { or: filter }
    end

    def build_query
      if query.present?
        { must: build_query_from(field, "#{query}*", default_operator: :and) }
      end
    end

    def refresh!
      super

      @script = nil
    end

    private

    def untouched_field
      "#{field}.untouched".to_sym
    end

    def populate_facets(results)
      values = results['terms'].map do |term|
        value = term['term']

        params        = create_result_params(value)
        add_params    = create_result_add_params(value)
        remove_params = create_result_remove_params(value)

        Result.new(value, term['count'], params, add_params, remove_params)
      end

      if results['missing'] > 0
        params        = create_result_params(missing_facet_name)
        add_params    = create_result_add_params(missing_facet_name)
        remove_params = create_result_remove_params(missing_facet_name)

        values << Result.new(missing_facet_name, results['missing'], params, add_params, remove_params)
      end

      values
    end

    class Result < Facet::Result
      def missing
        value == 'missing'
      end

      alias :missing? :missing
    end
  end
end
