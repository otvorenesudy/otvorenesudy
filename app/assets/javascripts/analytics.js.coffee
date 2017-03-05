$(document).ready ->
  $('[data-track-category]').click ->
    element = $(this)
    category = element.attr('data-track-category')
    action = element.attr('data-track-action')
    label = element.attr('data-track-label') || element.attr('id')

    _gaq?.push ['_trackEvent', category, action, label]
