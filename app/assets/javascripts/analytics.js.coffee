# TODO update

$(document).ready ->
  $('[data-track]').click ->
    label = $(this).attr 'data-track'
    _gaq.push ['_trackEvent', 'Actions', 'Click', label]
