$(document).ready ->
  window.defined = (value) ->
    typeof(value) != 'undefined'

  window.fixes = ->
    $('a[data-toggle="popover"]').popover(container: 'body')
    $('a[data-toggle="tooltip"]').tooltip(container: 'body')

    $('.collapse.hide-after-show').on 'show', ->
      id     = $(this).attr('id')
      button = $("[data-target=\"##{id}\"]")

      button.hide()

    # TODO fix tooltips and popovers in collapse
    $('.collapse').on 'shown', ->
      $(this).css('overflow', 'visible')

    $('.collapse').on 'hide', ->
      $(this).css('overflow', 'hidden')

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
