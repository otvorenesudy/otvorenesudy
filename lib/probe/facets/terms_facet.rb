class Probe::Facets
  class TermsFacet < Probe::Facets::Facet
    include Probe::Search::Query

    attr_accessor :script

    def build(index, name, options)
      index.facet name, options do |f|
        facet_options = Hash.new

        facet_options[:size] = @size

        if block_given?
          yield f, facet_options
        else
          f.terms not_analyzed_field(@field), facet_options
        end
      end
    end

    def build_filter
      terms.map do |value|
        if value == missing_facet_name
          { missing: { field: not_analyzed_field(@field), existence: true }}
        else
          { term: { not_analyzed_field(@field) => value }}
        end
      end
    end

    def build_suggest_query(term)
      build_query_filter_from(@field, "#{sanitize_query_string(term)}*", operator: :and)
    end

    def build_suggest_facet(index, options)
      build(index, name, options) do |f, facet_options|
        facet_options.merge! @script.build if @script

        f.terms not_analyzed_field(@field), facet_options
      end
    end

    def add_facet_script(script)
      @script = script
    end

    private

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
