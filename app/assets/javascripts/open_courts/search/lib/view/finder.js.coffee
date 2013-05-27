View.Finder =
  elementValue: (selector) ->
    $(selector).text()

  findValue: (selector, attr) ->
    @.log "Finding value  ... (selector=#{selector}, attribute=#{attr}"

    $(selector).closest("[#{attr}]").attr(attr)

  findElementByValue: (selector, value) ->
    $(selector).find("*[data-value='#{value}']")

