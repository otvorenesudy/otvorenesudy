Util.View.Loading =
  loading: (element, options) ->
    @.log "Loading ... (element=#{element}, options=#{JSON.stringify options})"

    $(element).empty() if options.reload
    $(element).append(@template['spinner'])

    $(element).find('.spinner').spin
      lines: 12
      color: "#999"
      length: 10
      radius: 12
      corners: 1
      hwaccel: true
      zIndex: 900
      className: "inner"

    @.scrollTo?("#{element} .spinner") if options?.scrollTo? is true
    
    options.callback?()

  unloading: (element) ->
    @.log "Unloading ... (element=#{element})"

    $(element).find('.spinner').spin(false).remove()

  loadMoreButton: (element) ->
    $(element).append(@template['load_more'])


