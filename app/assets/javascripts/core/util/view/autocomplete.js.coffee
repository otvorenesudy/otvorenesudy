Util.View.Autocomplete =
  autocomplete: (entity, options) ->
    el = "##{entity}"
    selectfc = options.selectfn
    
    @.log "Setting up autocomplete: #{entity}"

    $(el).autocomplete
      source: (request, response) ->
        $.ajax
          url: "/autocomplete/#{entity}"
          dataType: "json"
          data:
            term: request.term
          success: (d) ->
            response d.data
      select: (event, ui) ->
        selectfc(event, ui)

        $(this).val('')

        false

