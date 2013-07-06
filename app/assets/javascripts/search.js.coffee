#= require lib/lib

$(document).ready ->
  class window.Search extends Module
    @include Initializer
    @include Logger

    constructor: (model, el, options) ->
      @.log 'Initializing search ...'

      @model   = model
      @el      = $(el)
      @results = $(options.results)

      #@.focusSearchView()

      @.setup(options) if options?

      @.registerEvents()

    facets: ->
      $(@el).find('.facet')

    registerEvents: ->
      @.log 'Registering events ...'

      @.registerSubmit()
      @.registerSuggest()
      @.registerSelect()
      @.registerSearch()
      @.registerCollapse()

    registerSubmit: ->
      $(@el).find('form button.submit, form input[type="checkbox"]').click ->
        $(this).closest('form').submit()

    registerSuggest: ->
      facets = @.facets()

      @.log "Applying suggest to #{facets.length} facets."

      for facet in facets
        input = $(facet).find('input').first()
        @.suggest(input) if input.length > 0

    registerSelect: ->
      $(@el).find('form select').on 'change', ->
        $(this).closest('form').submit()

    registerSearch: ->
      $(@el).find('.facet ul li a, form a, .btn-group a').click => @.onSearch()
      $(@el).submit => @.onSearch()

    onSearch: ->
      $(@results).find('a').click (e) -> e.preventDefault()
      $(@results).find('a').addClass('disabled')

      $(@results).fadeTo('slow', 0.25)

# TODO rm but leave settings somewhere for future reference
#      $(@el).find('.spinner').spin
#        lines: 12
#        color: "#999"
#        length: 10
#        radius: 12
#        corners: 1
#        hwaccel: true
#        zIndex: 900
#        className: "inner"

    focusSearchView: ->
      scrollTo($(@el).position().top)

    registerCollapse: ->
      model = @model

      $('.facet [data-toggle="collapse"]').click ->
        name      = $(this).closest('.facet').attr('data-id')
        collapsed = $($(this).attr('data-target')).hasClass('in')

        # TODO: use config or anything else for the path
        $.get '/search/collapse', { model: model, name: name, collapsed: collapsed }

    suggest: (input) ->
      name = $(input).attr('data-id')
      path = $(input).attr('data-suggest-path')

      @.log "Setting up suggesting for #{name} with path #{path}"

      $(input).autocomplete
        minLength: 0
        source: (request, response) ->
          terms = []

          for i in $(input)
            terms.push($(i).val())

          $.ajax
            url: path
            type: 'GET'
            data:
              name: name
              term: terms.join(' ')
            success: (html) ->
              $(input).closest('.facet-content').find('.facet-results').html(html)
