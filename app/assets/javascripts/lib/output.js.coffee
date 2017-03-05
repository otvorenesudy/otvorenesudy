#= require lib/config

class window.Output
  @format: (s) ->
    "[#{Config.application}] #{s}"

  @print: (s) ->
    console.log(Output.format(s)) if window.Config.debug

  @warn: (s) ->
    console.warn(Output.format(s)) if window.Config.debug

  @error: (s) ->
    console.error(Output.format(s)) if window.Config.debug
