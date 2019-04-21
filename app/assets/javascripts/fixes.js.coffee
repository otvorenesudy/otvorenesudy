$(document).ready ->
  window.defined = (v) ->
    typeof(v) != 'undefined'

  window.fixes = ->
    $('a[href="#"]').click (e) ->
      e.preventDefault()

    $('a[data-toggle="collapse"]').click ->
      $(this).blur()

    $('a[data-toggle="collapse"][data-content]').click ->
      e = $(this)
      c = e.attr('data-content')
      e.attr('data-content', e.html()) and e.html(c)

    options = {
      container: 'body',
      constraints: [{
        to: 'scrollParent',
        attachment: 'together',
        pin: true
      }],
      html: true
    }

    $('a[data-toggle="popover"]').popover(options)
    $('a[data-toggle="tooltip"]').tooltip(options)

  fixes()
