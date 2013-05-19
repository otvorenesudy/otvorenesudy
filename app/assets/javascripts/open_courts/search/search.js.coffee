#= require       ./lib/lib
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

$(document).ready =>
  class OpenCourts.Search.App extends window.Module
    @include Logger

    constructor: (options) ->
      @modelClass = options.model

    start: ->
       @model      = new @modelClass
       @router     = new OpenCourts.SearchRouter model: @model
       @view       = new OpenCourts.SearchView   model: @model

       Backbone.history.start()

       @.log 'App is running.'
