$(document).ready ->
  window.defined = (value) ->
    typeof(value) != 'undefined'

  window.fixes = ->
    $('a[data-toggle="popover"]').popover()
    $('a[data-toggle="tooltip"]').tooltip()

    $('.tablesorter-wrapper').removeAttr('style')

    $('a[href="#"]').click (event) ->
      event.preventDefault()

    window.fixTabs = ->
      $('a[data-toggle="tab"]').click (e) -> e.preventDefault()

      $('a[data-toggle="tab"]').on 'shown', (e) ->
        e.preventDefault()

        hash = $(e.target).attr('href')

        $('body').trigger(window.hashChangeEvent, hash)

      if location.hash != ''
        hash     = window.getHash()
        selector = "a[href='#{hash}']"

        if $(selector).length > 0
          $(selector).tab('show')

    window.fixTabs()

  fixes()
