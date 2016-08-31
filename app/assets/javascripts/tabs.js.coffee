$(document).ready ->
  $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
    window.location.hash = $(e.target).attr('data-target').replace('tab-pane-', '')

  hash = window.location.hash

  if hash != ''
    $("a[data-target=\"#{hash.replace('#', '#tab-pane-')}\"]").tab('show')
  else
    $('a[data-toggle="tab"]:first').tab('show')
