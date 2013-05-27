window.delegate = (methods, options) ->
  for method in methods
    do(method) ->
      if method instanceof Object
        for own property of method
          source_method = property
          break
        target_method = method[source_method]
      else
        source_method =  target_method = method

      options.from[source_method] = ->
        if typeof options.to is "function"
          target = options.to.apply(options.from)
        else
          target = options.to
        target[target_method].apply(target, arguments)


