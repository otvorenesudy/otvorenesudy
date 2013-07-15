class Probe.Output
  @puts: (msg) ->
    console.log("[#{Config.appName}] #{msg}") if window.Config.debug
