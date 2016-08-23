$(document).ready ->
  window.hashChangeEvent = jQuery.Event("hash:change")

  window.getHash = ->
    window.location.hash.replace("!/", "")

  $("html, body").on "hash:change", (e, hash) ->
    window.location.hash = "!/#{hash.replace('#', '')}"
