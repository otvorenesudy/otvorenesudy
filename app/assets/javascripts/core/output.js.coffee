class window.Output
  @puts: (msg) ->
    console.log(msg) if window.Config.debug
