$(document).ready ->
  window.fixes = ->
    $('a[rel="popover"]').popover()
    $('a[rel="tooltip"]').tooltip()
  
    $('a[href="#"]').click ->
      return false
    
  fixes()
