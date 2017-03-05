class window.Module
  @_reserved:
    ['included', 'extended']

  @extend: (module) ->
    for name, fn of module when name not in window.Module._reserved
      @[name] = fn

    module.extended?.apply(@)
    this

  @include: (module) ->
    for name, fn of module when name not in window.Module._reserved
      @::[name] = fn

    module.included?.apply(@)
    this
