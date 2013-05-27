class DV.Page extends Backbone.Model
  defaults:
    hidden: true,
    type: "scan"

  initialize: (options) ->
    @annotations = new DV.Comments(options.comments)

  setAttachment: (attachment) ->
    @attachment = attachment

  show: ->
    @set(hidden: false)

  hide: ->
    @set({hidden: true}, {silent: true})

  showFulltext: ->
    @set(type: "fulltext")

  showScan: ->
    @set(type: "scan")

  getText: ->
    @get("text") or @loadText()

  loadText: ->
    $.get(@get("textUrl"), (data) => @set(text: data))

  getNumber: ->
    @get("number")

  showAnnotation: (annotationId) ->
    annotation = @annotations.detect (annotation) -> annotation.get("id") == annotationId
    annotation.show() if annotation
