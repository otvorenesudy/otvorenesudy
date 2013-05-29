#= require ./logger

class window.UrlParser
  @validate: (params) ->
    # TODO: Fix weird error in firefox not caching exceptions
    return false if params? and params.length == 0

    try
      @.parse(params)
    catch error
      Logger.log "Validation failed. (params=#{params}, error: #{error.message})"
      return false
    return true

  @check: (value) ->
    unless value instanceof Array
      throw "Wrong type."

  @decode: (str) ->
    decodeURI(str.replace(/\+/g, ' '))

  @encode: (value) ->
    value.join(';').replace(/\s/g, '+')

  @parseParam: (param) ->
    param = param.split(':')

    attr  = param[0]
    value = @.decode(param[1]).split(';')

    Logger.log "Parsing #{attr}: #{value}"

    return [attr, value]

  @parse: (data) ->
    params = data.split('&')

    result = {}
    for param in params
      param = @.parseParam(param)

      @.check(param[1])

      result[param[0]] = param[1]

    result

  @dump: (json) ->
    str = ""
    for key, value of json
      str += "#{key}:#{@.encode(value)}&" if value?.length > 0
    str.replace(/&$/, '')

