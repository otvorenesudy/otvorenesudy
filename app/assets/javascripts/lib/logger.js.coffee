#= require lib/output

window.Logger =
  prefix: ->
    @constructor.name

  inspect: (o) ->
    try
      JSON.stringify o
    catch e
      return "<Could not be inspected. (error=#{e.message})>"

  log: (s) ->
    Output.print "#{@.prefix()} > #{s}"

  warn: (s) ->
    Output.warn "#{@.prefix()} [WARNING] #{s}"

  error: (s) ->
    Output.error "#{@.prefix()} [ERROR] #{s}"
