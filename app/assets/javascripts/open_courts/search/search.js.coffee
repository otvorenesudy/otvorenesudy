#= require       core/core
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

$(document).ready =>
  class OpenCourts.Search.App extends window.Module
    @include Util.Logger

    start: ->
       @model  = new OpenCourts.SearchModel
       @router = new OpenCourts.SearchRouter model: @model
       @view   = new OpenCourts.SearchView model: @model

       Backbone.history.start()

       @.log 'App is running.'
