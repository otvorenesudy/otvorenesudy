class DV.Rescaled
  BASE_WIDTH: 673
  BASE_HEIGHT: 990

  constructor: (options) ->
    @model      = options.model
    @dimensions = options.dimensions

    for property of @model
      delegate([property], {from: this, to: @model}) unless this[property]

  y1: ->
    @rescaleVertical(@model.y1())

  x1: ->
    @rescaleHorizontal(@model.x1())

  width: ->
    @rescaleHorizontal(@model.width())

  height: ->
    @rescaleVertical(@model.height())

  rescaleHorizontal: (x) ->
    x * (@dimensions.documentWidth() / @BASE_WIDTH)

  rescaleVertical: (y) ->
    y * (@dimensions.documentHeight() / @BASE_HEIGHT)
