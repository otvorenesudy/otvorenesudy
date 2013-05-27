class DV.AnnotationAreaView extends Backbone.View
  tagName: 'div'
  className: 'comment_area'

  render: ->
    $(@el).css
      "z-index" : 99
      position  : 'absolute'
      display   : 'none'
      top       : @model.y1()
      left      : @model.x1()
      width     : @model.width()
      height    : @model.height()

  show: ->
    $(@el).css(display: 'inline-block')

  hide: ->
    $(@el).css(display: 'none')

