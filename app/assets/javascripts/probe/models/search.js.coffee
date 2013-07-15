#= require jquery

class Probe.Search extends Backbone.Model
  @include Probe.Logger

  initialize: (options) ->
    @search = options.search
    @facets = options.facets

  search: (callback) ->
    @.log 'Starting search...'

    $.ajax
      url:       @search.path
      type:      @search.method
      dataType:  'json'
      data:      @.toQuery()

      success: (response) =>
        @.log "Response: #{@.inspect response}"

        callback?(response)
      error: (error) =>
        @.err "Error occured while searching (model=#{@.toJSON()})"

        # dirty fix for server errors
        document.write(error.responseText)
