window.scrollTo = (position) ->
  $('html, body').scrollTop(position - $('.navbar').height())
