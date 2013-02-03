Util.View.Slider =
  slider: (entity, options = {}) ->
    @.log "Setting up slider: #{entity}"

    el = "##{entity}-slider"

    opt =
      range:  options.range?  or true
      min:    options.min?    or @model.get(entity)[0]
      max:    options.max?    or @model.get(entity)[1]
      values: options.values? or @model.get(entity)
      slide:  options.slide?  or (event, ui) =>
        @.onChangeSlider event, ui, entity
      change: options.change? or (event, ui) =>
        @.onChangeSlider event, ui, entity
      stop:   options.stop?   or (event, ui) =>
        @model.set entity, ui.values

    $(el).slider(opt)

    values = options?.values or @model.get(entity)

    @.onChangeSlider null, values: values, entity

