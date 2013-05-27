class DV.Browser
  @cursor = (type) ->
    switch type
      when 'grab' then @vendor_specific_grab()
      when 'grabbing' then @vendor_specific_grabbing()

  @vendor_specific_grab = ->
    return "-moz-grab" if $.browser.mozilla
    return "-webkit-grab" if $.browser.webkit
    "move"

  @vendor_specific_grabbing = ->
    return "-moz-grabbing" if $.browser.mozilla
    return "-webkit-grabbing" if $.browser.webkit
    "move"
