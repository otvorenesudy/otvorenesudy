#= require_tree ./lib

$(document).ready ->
  class window.Search extends Module
    @include Initializer
    @include Logger

    constructor: (model, options) ->
      @.log "search on #{options.element}"

      @model   = model
      @element = $(options.element)
      @results = $(options.results)

      @.setup(options) if options?

      @.registerEvents()

    registerEvents: ->
      @.registerSubmit()
      @.registerSuggest()
      @.registerSelect()
      @.registerSearch()
      @.registerCollapse()

    registerSubmit: ->
      $(@element).find('form button.submit, form input[type="checkbox"]').click ->
        $(this).closest('form').submit()

    registerSuggest: ->
      suggest = new Search.Suggest(@element)

      suggest.register()

    registerSelect: ->
      $(@element).find('form select').on 'change', ->
        $(this).closest('form').submit()

    registerSearch: ->
      $(@element).find('.facet ul li a, form a, .btn-group a:not(.active)').click (e) => @.onSearch()
      $(@element).find('form input').change => @.onSearch()
      $(@element).submit => @.onSearch()
      $(@element).find('.search-reset').click => @.onSearch()

    onSearch: ->
      $(@results).find('a').click (e) -> e.preventDefault()
      $(@results).find('a').addClass('disabled')

    registerCollapse: ->
      model = @model

      $('.facet .facet-title[data-toggle="collapse"]').click ->
        name      = $(this).closest('.facet').attr('data-id')
        collapsed = $($(this).attr('data-target')).hasClass('show')

        $.get '/search/collapse', { model: model, name: name, collapsed: collapsed }

  class window.Search.Suggest extends Module
    @include Logger

    constructor: (element) ->
      @element = element

    register: ->
      facets = $(@element).find('.facet')

      for facet in facets
        input = $(facet).find('input').first()

        @.registerSuggest(input) if input.length > 0

    registerSuggest: (input) ->
      name = $(input).attr('data-id')
      path = $(input).attr('data-path')

      @.log "suggest on #{name} via #{path}"

      $(input).autocomplete
        minLength: 0
        source: (request, response) ->
          results = $(input).closest('.facet-content').find('.facet-results ul')

          $(results).find('a').click (e) -> e.preventDefault()
          $(results).find('a').addClass('disabled')

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
              $(input).closest('.facet-content').find('.facet-results').html(html)

              fixes()
