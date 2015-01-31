module Probe
  module Suggest
    extend ActiveSupport::Concern

    module ClassMethods
      include Probe::Helpers::Index
      include Probe::Sanitizer

      def suggest(name, term, params, options = {})
        facet = facets[name]

        return unless facet && facet.suggestable?

        options[:name]        = index.name
        options[:params]      = params
        options[:facets]      = facets
        options[:sort_fields] = @sort_fields

        search = Search::Composer.new(self, options)

        search.compose do
          filter_options = Hash.new

          if term.present?
            script = Facets::Script.new(Probe::Configuration.script.suggest)

            script.add_script_params(query: term)
            facet.add_facet_script(script)

            filter_options[:queries] = facet.build_suggest_query(term)
          end

          filter_options[:exclude] = facet

          filter = build_facet_filter(filter_options)

          facet_options = {
            global: true,
            facet_filter:  filter
          }

          facet.build_suggest_facet(@index, facet_options)

          if facet.active?
            facet_options = {
              global: true,
              facet_filter:  build_facet_filter
            }

            facet.build(@index, facet.selected_name, facet_options)
          end
        end
      end
    end
  end
end
