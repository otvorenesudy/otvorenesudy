class DV.ZoomView extends Backbone.View
  template: JST['document_viewer/templates/zoom']

  events:
    "click ._dv_zoom_in":     "zoomIn",
    "click ._dv_zoom_out":    "zoomOut"

  initialize: (options) ->
    @dv = options.dv
    @dv.bind("document:change:type", @onDocumentModeChanged, @)
    @dv.bind("change:mode", @onDocumentModeChanged, @)

  render: ->
    $(@el).html(@template())

  zoomIn: ->
    @dv.zoomIn()
    false

  zoomOut: ->
    @dv.zoomOut()
    false

  onDocumentModeChanged: ->
    if @dv.showsDocument() and @dv.showsScan()
      $(@el).show()
    else
      $(@el).hide()
