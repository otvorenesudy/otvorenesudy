Util.View.Suggest =
  suggest: (entity, options = {}) ->
    el = "##{entity}"

    @.log "Setting up suggesting for #{entity}"

    $(el).autocomplete
      minLength: 0
      messages:
        noResults: null,
        results: -> {}
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

    @.suggest(entity, options)
      .data('autocomplete')._renderItem = (ul, item) =>
        # TODO: append 'No item found' if there is not item found :)
        @.findOrCreateListItem(entity, item.alias, item.value, item.count)

