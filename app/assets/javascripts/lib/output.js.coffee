#= require lib/config

class window.Output
  @format_msg: (msg) ->
    "[#{Config.appName}] #{msg}"

  @puts: (msg) ->
    console.log(Output.format_msg(msg)) if window.Config.debug

  @warn: (msg) ->
    console.warn(Output.format_msg(msg)) if window.Config.debug

  @error: (msg) ->
    console.error(Output.format_msg(msg)) if window.Config.debug
