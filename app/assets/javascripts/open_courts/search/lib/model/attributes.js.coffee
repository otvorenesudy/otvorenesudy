Model.Attributes =
  setupAttribute: (attr) ->
    @.log "Initializing attribute: #{attr}"

    @[attr] = clone(@.get(attr))

  getValue: (attr, pos) ->
    (@.get attr)[pos or 0]

  setValue: (attr, value, options) ->
    values = clone(@.get attr)

    values[options?.pos or 0] = value

    @.set attr, values, options

  add: (attr, value, options) ->
    @.setupAttribute(attr)

    @.log "Adding to '#{attr}': #{value} ... (options=#{@.inspect options}"

    if options?.multi
      @[attr].push(value) unless value in @[attr]
    else
      @[attr] = [value]

    @.log "Setting '#{attr}': #{@.inspect @[attr]}"

    @.set(attr, @[attr], silent: options?.silent)

  remove: (attr, value, options) ->
    @.setupAttribute(attr)

    @.log "Removing from '#{attr}': #{value}"

    @[attr].remove(value)

    @.log "Setting '#{attr}': #{@.inspect @[attr]}"

    @.set(attr, @[attr], silent: options?.silent)

