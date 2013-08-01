module Probe::Search
  class Suggester
    def initialize(probe)
      @probe  = probe
      @facets = @probe.facets
    end

    def suggest(name, term, params, options)
      facet = @facets[name]

      return unless facet.suggestable?

      search = Composer.new(self, options)

      search.compose do
        filter_options = Hash.new

        if term.present?
          script = Facets::Script.new(Probe::Configuration.script.suggest)

          script.add_script_params(query: term)

          facet.script = script
        end

        filter_options[:exclude] = facet

        filter = build_facet_filter(filter_options)

        facet_options = {
          global: true,
          facet_filter:  filter
        }

        facet.build_suggest_facet(@index, facet_options)
        facet.build(@index, facet.selected_name) if facet.active?
      end
    end
  end
end
