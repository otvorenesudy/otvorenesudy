$(document).ready ->
  window.fixes = ->
    $('a[rel="popover"]').popover()
    $('a[rel="tooltip"]').tooltip()

    $('a[href="#"]').click (event) ->
      event.preventDefault()

    # Fix for tab hashcode in url
    # from: http://stackoverflow.com/questions/9685968/best-way-to-make-twitter-bootstrap-tabs-persistent
    window.fixTabs = ->
      window.scrollToTabs =  (el) ->
        # TODO: remove relative navbar height if navbar does not stay fixed
        $(document).scrollTop(el.closest('ul.nav').offset().top - $('.navbar').height() - 10)

      if location.hash != ''
        selector = "a[href='#{location.hash}']"

        if $(selector).length > 0
          $(selector).tab('show')

          scrollToTabs($(selector))

      $('a[data-toggle="tab"]').on 'shown', (e) ->
        window.location.hash = $(e.target).attr('href').substr(1)

        scrollToTabs($(this))

      $('a[data-toggle="tab"]').click (e) ->
        e.preventDefault()

    window.fixTabs()

  fixes()
