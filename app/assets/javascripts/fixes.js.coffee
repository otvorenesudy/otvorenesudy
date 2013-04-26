$(document).ready ->
  window.fixes = ->
    $('a[rel="popover"]').popover()
    $('a[rel="tooltip"]').tooltip()

    $('a[href="#"]').click (event) ->
      event.preventDefault()

    # Fix for tab hashcode in url
    # from: http://stackoverflow.com/questions/9685968/best-way-to-make-twitter-bootstrap-tabs-persistent
    #if location.ha#sh != ''
      #$("a[href='#{location.hash}']").tab('show')

    #$('a[data-toggle="tab"]').on 'shown', (e) ->
      #location.hash = $(e.target).attr('href').substr(1)

    #$('a[data-toggle="tab"]').click (e) ->
      #e.preventDefault()

  fixes()
