Util.View.Loading =
  loading: (element, options) ->
    @.log "Loading ... (element=#{element}, options=#{JSON.stringify options})"

    $('.btn-load-more').remove()

    $(element).empty() if options.reload
    $(element).append(@template['spin'])

    $(element).find('.spin').spin
      lines: 13
      color: "#878787"
      length: 10
      radius: 15
      corners: 1

    @.scrollTo?("#{element} .spin") if options?.scrollTo? is true

  unloading: (element) ->
    @.log "Unloading ... (element=#{element})"

    $(element).find('.spin').spin(false).remove()

  loadMoreButton: (element) ->
    $(element).append(@template['load_more'])


