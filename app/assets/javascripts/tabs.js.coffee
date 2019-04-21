$(document).ready ->
  $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
    $(e.target).attr('tabindex', -1)

    window.location.hash = $(e.target).attr('data-target').replace('tab-pane-', '')

  $('a[data-toggle="tab"]').on 'hidden.bs.tab', (e) ->
    $(e.target).removeAttr('tabindex')

  hash = window.location.hash

  if hash != '' or $('a.active[data-target="tab"]').length == 0
    $("a[data-target=\"#{hash.replace('#', '#tab-pane-')}\"]").tab('show')
  else
    $('a[data-toggle="tab"]:first').tab('show')
