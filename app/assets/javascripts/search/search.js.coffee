#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./routers
#= require_tree ./views
#= require core/util/logger

$(document).ready ->
  class OpenCourts.SearchApp extends window.Module
    @include Util.Logger

    init: ->
      @model  = new OpenCourts.SearchModel
      @router = new OpenCourts.SearchRouter model: @model
      @view   = new OpenCourts.SearchView model: @model

      Backbone.history.start()

      @.log 'App initialized.'

  (new OpenCourts.SearchApp).init()
