$(document).ready ->
  $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
    $(e.target).attr('tabindex', -1)

    history.pushState(null, null, $(e.target).attr('href'))

  $('a[data-toggle="tab"]').on 'hidden.bs.tab', (e) ->
    $(e.target).removeAttr('tabindex')

  if window.location.hash != ''
    $("a[data-toggle=\"tab\"][href=\"#{window.location.hash}\"]").tab('show')
  else
    $("a[data-toggle=\"tab\"]:first").tab('show')
