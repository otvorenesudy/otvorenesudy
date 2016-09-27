$(document).ready ->
  window.defined = (v) ->
    typeof(v) != 'undefined'

  window.fixes = ->
    $('a[href="#"]').click (e) ->
      e.preventDefault()

    $('a[data-toggle="collapse"][data-toggle-content]').click ->
      e = $(this)
      c = e.attr('data-toggle-content')
      e.attr('data-toggle-content', e.html()) and e.html(c)

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
