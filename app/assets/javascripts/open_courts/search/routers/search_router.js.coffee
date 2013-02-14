#= require core/url_parser

class OpenCourts.SearchRouter extends Backbone.AbstractRouter
    @include Util.Logger

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

        @model.set
          page:     json.page     or []
          category: json.category or []
          judges:   json.judges   or []
          court:    json.court    or []
          date:     json.date     or []

    format: (json) ->
      UrlParser.dump json

    adjustUrl: ->
      url = @.format @model.toJSON()
      
      @.log "Navigating to url: '#{url}'"
      @.navigate url

