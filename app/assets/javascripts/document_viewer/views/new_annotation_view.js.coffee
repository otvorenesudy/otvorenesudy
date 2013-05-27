class DV.NewAnnotationView extends Backbone.View
  template: JST['document_viewer/templates/new_annotation']

  events:
    "click .cancel": "cancelAnnotating"
    "click .submit": "createAnnotation"

  initialize: (options) ->
    @dv = options.dv
    @parentView = options.parentView
    @placementAlgorithm = new DV.Placement(@dv.getWidth())

  render: (options) ->
    @model.set(area: options.area)
    html = @template(user: @dv.getCurrentUser())
    $(@el).html(html)
    $(@parentView.el).append($(@el)) # @el needs to get in DOM in order to have its height calculated
    placement = @placementAlgorithm.position($(@el), { relativeTo: @model, bottom: @parentView.scrollBottom() })
    $(@el).css
      position: 'absolute'
      "z-index": 99999
      top: placement.top
      left: placement.left
      width: placement.width
    @$('textarea').focus()
    $(@el)

  cancelAnnotating: ->
    @remove()
    @dv.toggleAnnotatingMode()
    false

  createAnnotation: ->
    @model.set(comment: @$('textarea').val())
    @$('textarea').val('')
    @remove()
    @trigger("created", @model)
