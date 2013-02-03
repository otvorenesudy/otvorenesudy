Util.Logger =
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
    @.log "[ WARNING ] #{msg}"

  err: (msg) ->
    @.log "[ ERROR ] #{msg}"
    

