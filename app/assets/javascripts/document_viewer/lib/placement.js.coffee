class DV.Placement
  DEFAULT_PADDING: 10

  constructor: (@width) ->

  position: (element, { relativeTo, bottom }) ->
    placement = {}

    placement.top = relativeTo.y1() + relativeTo.height() + @DEFAULT_PADDING

    if element and bottom - placement.top < element.height() + @DEFAULT_PADDING
      placement.top = relativeTo.y1() - element.height() - @DEFAULT_PADDING

    placement.width = @width
    placement.left = 0

    placement

