module Probe
  module Suggest
    extend ActiveSupport::Concern

    module ClassMethods
      include Probe::Helpers::Index
      include Probe::Sanitizer

      def suggest(name, term, params, options = {})
        facet = facets[name]

        return unless facet.suggestable?

        options[:name]        = index.name
        options[:params]      = params
        options[:facets]      = @facets
        options[:sort_fields] = @sort_fields

        script = Facets::Script.new(Probe::Configuration.script.suggest)

        script.add_script_params(query: term)

        search = Search::Composer.new(self, options)

        search.compose do
          facet.add_facet_script(script)

          filter_options = Hash.new

          filter_options[:exclude] = facet
          filter_options[:queries] = facet.build_suggest_query(term) if term.present?

          filter = build_facet_filter(filter_options)

          facet_options = {
            global_facets: false,
            facet_filter:  filter
          }

          facet.build_suggest_facet(@index, facet_options)

          if facet.active?
            facet_options = {
              global_facets: false,
              facet_filter:  build_facet_filter
            }

            facet.build(@index, facet.selected_name, facet_options)
          end
        end
      end
    end
  end
end
