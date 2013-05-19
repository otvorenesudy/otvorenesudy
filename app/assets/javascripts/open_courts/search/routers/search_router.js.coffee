#= require open_courts/search/lib/url_parser

class OpenCourts.SearchRouter extends Backbone.AbstractRouter
    @include Logger

    routes:
      "*params": "onSearch"

    initialize: (options) ->
      @.log 'Initializing...'

      @model = options.model

      @model.bind "change", =>
        @.adjustUrl()

      @.log 'Initialized.'

    onSearch: (params) ->
      @.log "Catching url ... (params=#{@.inspect params})"

      if UrlParser.validate params
        json = UrlParser.parse params

        @.log "Updating model ... (json=#{@.inspect json})"

        data = {}

        for field of @model.defaults
          data[field] = json[field]  || []

        @.log "Updating model with formated data ... (data=#{@.inspect data})"

        @model.set data

    format: (json) ->
      UrlParser.dump json

    adjustUrl: ->
      url = @.format @model.toJSON()

      @.log "Navigating to url: '#{url}'"
      @.navigate url

