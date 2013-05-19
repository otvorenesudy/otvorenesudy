View.Finder =
  elementValue: (selector) ->
    $(selector).text()

  findValue: (selector, attr) ->
    @.log "Finding value  ... (selector=#{selector}, attribute=#{attr}"

    element = $(selector)
    value   = element.attr(attr)

    until value or !element.length
      @.log "Finding in element: '#{@.inspect element}'"

      element = element.parent()
      value   = element.attr(attr)

    value

  findElementByValue: (selector, value) ->
    $(selector).find("*[data-value='#{value}']")

