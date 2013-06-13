#= require lib/output

window.Logger =
  prefix: ->
    @constructor.name

  inspect: (obj) ->
    try
      JSON.stringify obj
    catch err
      return "<Could not be inspected. (error=#{err.message})>"

  log: (msg) ->
    Output.puts "#{@.prefix()} > #{msg}"

  warn: (msg) ->
    Output.warn "#{@.prefix()} [WARNING] #{msg}"

  err: (msg) ->
    Output.error "#{@.prefix()} [ERROR] #{msg}"
