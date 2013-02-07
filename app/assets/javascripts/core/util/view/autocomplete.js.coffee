Util.View.Autocomplete =
  autocomplete: (entity, options = {}) ->
    el = "##{entity}"
    
    @.log "Setting up autocomplete: #{entity}"

    $(el).autocomplete
      messages:
        noResults: null,
        results: -> {}
      source: (request, response) ->
        options.refresh?(entity)

        $.ajax
          url: "/autocomplete/#{entity}"
          dataType: "json"
          data:
            term: request.term
          success: (d) ->
            response d.data
  
  autocompleteList: (entity, options = {}) ->
    options.refresh = (entity) =>
      @.clearList(entity, selected: true)

    @.autocomplete(entity, options)
      .data('autocomplete')._renderItem = (ul, item) =>
        @.findOrCreateListItem(entity, item.term, item.count)

