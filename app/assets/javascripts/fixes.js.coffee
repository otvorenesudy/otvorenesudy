$(document).ready ->
  $('a[rel="popover"]').popover()
  $('a[rel="tooltip"]').tooltip()

  $('a[href="#"]').click ->
    return false
