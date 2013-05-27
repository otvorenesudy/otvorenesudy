class DV.MarkerView extends Backbone.View
  tagName: 'a'
  className: 'pencil2'

  isPermanentlyActive: false

  events:
    "mouseover": "activate"
    "mouseout" : "deactivate"
    "click"    : "activatePermanently"

  render: ->
    $(@el).css
      "z-index":   1
      float:       'right'
      display:     'inline-block'
      position:    'absolute'
      top:         @model.y1()
      right:       '20px'

  activate: ->
    return if @isPermanentlyActive
    $(@el).removeClass('pencil2')
    $(@el).addClass('pencil1')
    @trigger('activated')

  deactivate: ->
    return if @isPermanentlyActive
    $(@el).removeClass('pencil1')
    $(@el).removeClass('pencil3')
    $(@el).addClass('pencil2')
    @trigger('deactivated')

  activatePermanently: ->
    if @isPermanentlyActive
      $(@el).removeClass('pencil1')
      $(@el).removeClass('pencil2')
      $(@el).addClass('pencil2')
      @trigger('deactivated')
      @isPermanentlyActive = false
    else
      $(@el).removeClass('pencil1')
      $(@el).removeClass('pencil2')
      $(@el).addClass('pencil3')
      @trigger('activated')
      @isPermanentlyActive = true
    false
