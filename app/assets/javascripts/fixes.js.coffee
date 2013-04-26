$(document).ready ->
  window.fixes = ->
    $('a[rel="popover"]').popover()
    $('a[rel="tooltip"]').tooltip()

    $('a[href="#"]').click (event) ->
      event.preventDefault()

    # Fix for tab hashcode in url
    # from: http://stackoverflow.com/questions/12131273/twitter-bootstrap-tabs-url-doesnt-change
    hash = window.location.hash
    hash && $("ul.nav a[href='#{hash}']").tab('show')

    $('.nav-tabs a').click (e) ->
      e.preventDefault()

      $(this).tab('show')

      scrollmem = $('body').scrollTop()
      window.location.hash = $(this).attr('href')

      $('html,body').scrollTop(scrollmem)

  fixes()
