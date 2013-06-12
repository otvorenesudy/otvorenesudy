#= require lib/lib

$(document).ready ->
  class window.Search extends Module
    @include Initializer
    @include Logger

    constructor: (el, options) ->
      @.log 'Initializing search ...'

      @el      = $(el)
      @results = options.results

      @.focusSearchView()

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

    registerSubmit: ->
      $(@el).find('form button.submit, form input[type="checkbox"]').click ->
        $(this).closest('form').submit()

    registerSuggest: ->
      facets = @.facets()

      @.log "Applying suggest to #{facets.length} facets."

      for input in $(facets).find('input')
        @.suggest(input, $(input).attr('data-id'), $(input).attr('data-suggest-path'))

    registerSelect: ->
      $(@el).find('form select').on 'change', ->
        $(this).closest('form').submit()

    registerSearch: ->
      $(@el).find('.facet ul li a, form a').click => @.onSearch()
      $(@el).submit => @.onSearch()

    onSearch: ->
      $(@results).find('a').click (e) -> e.preventDefault()
      $(@results).find('a').addClass('disabled')

      $(@results).find('ol').fadeTo('slow', 0.25)
      $(@results).find('.spinner').spin
        lines: 12
        color: "#999"
        length: 10
        radius: 12
        corners: 1
        hwaccel: true
        zIndex: 900
        className: "inner"

    focusSearchView: ->
      scrollTo($(@el).position().top)

    suggest: (input, name, path) ->
      @.log "Setting up suggesting for #{name} with path #{path}"

      $(input).on 'keyup', ->
        term = $(this).val()

        $.ajax
          url: path
          type: 'GET'
          data:
            name: name
            term: term
          success: (html) ->
            $(input).parent().find('ul').html(html)
