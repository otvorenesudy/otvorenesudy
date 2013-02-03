Util.View.Finder =
  findValue: (selector, attr) ->
    @.log "Finding value  ... (selector=#{selector}, attribute=#{attr}"

    element = $(selector)
    value   = element.attr(attr)

    until value or !element.length
      @.log "Finding in element: '#{@.inspect element}'"

      element = element.parent()
      value   = element.attr(attr)

    value

