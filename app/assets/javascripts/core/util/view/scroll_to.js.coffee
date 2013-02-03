Util.View.ScrollTo =
  scrollTo: (element) ->
    try
      $('html, body').animate scrollTop: $(element).position().top
    catch error
      @.err "could not scroll to element '#{element}'"

