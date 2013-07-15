class Probe.SearchView extends Backbone.View
  @include Probe.Initializer

  initialize: (options) ->
    @.setup(options)

    for facet in @model.facets
      alert(facet)
