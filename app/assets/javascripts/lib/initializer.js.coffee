window.Initializer =
  setup: (options) ->
    for attr, value of options
      @[attr] = value
