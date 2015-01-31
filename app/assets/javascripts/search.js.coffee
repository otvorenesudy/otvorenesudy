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

      @.setup(options) if options?

      @.registerEvents()

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
      suggest = new Search.Suggest(@el)

      suggest.register()

    registerSelect: ->
      $(@el).find('form select').on 'change', ->
        $(this).closest('form').submit()

    registerSearch: ->
      $(@el).find('.facet ul li a, form a, .btn-group a:not(.active)').click (e) => @.onSearch()
      $(@el).find('form input').change => @.onSearch()
      $(@el).submit => @.onSearch()
      $(@el).find('.search-reset').click => @.onSearch()

    onSearch: ->
      $(@results).find('a').click (e) -> e.preventDefault()
      $(@results).find('a').addClass('disabled')

      $(@results).fadeTo('slow', 0.25)

    focusSearchView: ->
      scrollTo($(@el).position().top)

    registerCollapse: ->
      model = @model

      $('.facet [data-toggle="collapse"]').click ->
        name      = $(this).closest('.facet').attr('data-id')
        collapsed = $($(this).attr('data-target')).hasClass('in')

        # TODO: use config or anything else for the path
        $.get '/search/collapse', { model: model, name: name, collapsed: collapsed }

  class window.Search.Suggest extends Module
    @include Logger

    constructor: (el) ->
      @el = el

    register: ->
      facets = $(@el).find('.facet')

      @.log "Applying suggest to #{facets.length} facets."

      for facet in facets
        input = $(facet).find('input').first()

        @.registerSuggest(input) if input.length > 0

    registerSuggest: (input) ->
      name    = $(input).attr('data-id')
      path    = $(input).attr('data-suggest-path')

      @.log "Setting up suggesting for #{name} with path #{path}"

      $(input).autocomplete
        minLength: 0
        source: (request, response) ->
          results = $(input).closest('.facet-content').find('.facet-results ul')

          $(results).find('a').click (e) -> e.preventDefault()
          $(results).find('a').addClass('disabled')

          $(results).fadeTo('slow', 0.25)

          terms = []

          for i in $(input)
            terms.push($(i).val())

          $.ajax
            url: path
            type: 'GET'
            data:
              facet: name
              term: terms.join(' ')
            success: (html) ->
              setTimeout (-> $(input).closest('.facet-content').find('.facet-results').html(html)), 5000
