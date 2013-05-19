View.Suggest =
  suggest: (entity, options = {}) ->
    el = "##{entity}"

    @.log "Setting up suggesting for #{entity}"

    $(el).autocomplete
      minLength: 0
      messages:
        noResults: null,
        results: -> {}
      open: ->
        options.open?(entity)
      source: (request, response) ->
        options.refresh?(entity)

        data      = options.query?()
        data.term = request.term

        $.ajax
          url: "/suggest/#{entity}"
          dataType: "json"
          data: data
          success: (d) ->
            response d.data

  suggestList: (entity, options = {}) ->
    options.refresh = (entity) =>
      @.clearList(entity, selected: true)

    options.open = (entity) =>
      @.listCollapse(entity, visible: 10)

    @.suggest(entity, options)
      .data('autocomplete')._renderItem = (ul, item) =>
        # TODO: append 'No item found' if there is not item found
        @.findOrCreateListItem(entity, item.alias, item.value, item.count)

