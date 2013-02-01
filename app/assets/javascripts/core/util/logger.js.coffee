#= require core/output

window.Util.Logger =
  prefix: ->
    @constructor.name

  log: (msg) ->
    Output.puts "#{@.prefix()} > #{msg}"

  warn: (msg) ->
    @.log "[WARNING] #{msg}"

  err: (msg) ->
    @.log "[ERROR] #{msg}"
    

