window.Initializer =
  setup: (options) ->
    for attribute, value of options
      @[attribute] = value
