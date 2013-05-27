$(document).ready ->
  $.browser = {}

  agent = navigator.userAgent

  if agent.match(/firefox/i)
    $.browser.mozilla = true
  if agent.match(/webkit/i)
    $.browser.webkit = true


