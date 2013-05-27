class DV.AnnotationView extends Backbone.View
  initialize: (options) ->
    @parentView = options.parentView
    @dv = options.dv
    @model = new DV.Rescaled(model: @model, dimensions: @dv)
    @model.bind("highlight", @highlight, @)
    @dv.bind("change:zoom", @zoomChanged)
    @placementAlgorithm = new DV.Placement(@dv.getWidth())
    @dv.bind('change:annotationsPinned', @annotationsPinnedChanged, @)

  render: ->
    @popup = new DV.AnnotationPopupView(dv: @dv, model: @model)
    @area = new DV.AnnotationAreaView(model: @model)
    @marker = new DV.MarkerView(model: @model)

    @marker.bind('activated', @onMarkerActivated)
    @marker.bind('deactivated', @onMarkerDeactivated)

    renderedEl = $(@el).append(@area.render()).append(@popup.render()).append(@marker.render())
    @area.show() if @dv.areAnnotationsPinned()
    renderedEl

  onMarkerActivated: =>
    @area.show() unless @dv.areAnnotationsPinned()
    at = @placementAlgorithm.position(@popup, relativeTo: @model, bottom: @parentView.scrollBottom())
    @popup.show(at)

  onMarkerDeactivated: =>
    @area.hide() unless @dv.areAnnotationsPinned()
    @popup.hide()

  highlight: =>
    @marker.activatePermanently()
    @parentView.el.scrollIntoView()

  annotationsPinnedChanged: ->
    if @dv.areAnnotationsPinned()
      @area.show()
    else
      @area.hide()

  zoomChanged: ->
    @area.render()
    @marker.render()
    @popup.render()
