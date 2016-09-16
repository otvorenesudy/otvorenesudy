$(document).ready ->
  window.defined = (v) ->
    typeof(v) != 'undefined'

  window.fixes = ->
    $('a[href="#"]').click (e) ->
      e.preventDefault()

    options = {
      container: 'body',
      constraints: [{
        to: 'scrollParent',
        attachment: 'together',
        pin: true
      }],
      html: true,
      placement: 'top'
    }

    $('a[data-toggle="popover"]').popover(options)
    $('a[data-toggle="tooltip"]').tooltip(options)

  fixes()
