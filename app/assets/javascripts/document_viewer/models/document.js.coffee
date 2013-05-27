//= require document_viewer/models/page

class DV.Document extends Backbone.Model
  defaults:
    current_page: 1
    type: "scan"
    mode: "view"

  initialize: (document_attributes) ->
    @set("number": document_attributes.number)
    @set("name": document_attributes.name)
    @pages = new DV.Pages(document_attributes.pages)
    @pages.each (page) => page.setAttachment(@)

  showScan: ->
    @set(type: "scan")
    @pages.invoke "showScan"

  showFulltext: ->
    @set(type: "fulltext")
    @pages.invoke "showFulltext"

  getType: ->
    @get("type")

  setCurrentPage: (current_page) ->
    @set(current_page: current_page)

  getCurrentPage: ->
    @pages.at(@get("current_page") - 1)

  previousPage: ->
    current_page = @get("current_page") - 1
    @setCurrentPage(current_page)

  getTotalPages: ->
    @pages?.length

  getPages: ->
    @pages

  getNumber: ->
    @get("number")

  getName: ->
    @get("name")

  getCurrentPageNumber: ->
    @get("current_page")

  setCurrentPageNumber: (pageNumber) ->
    @set(current_page: pageNumber)

  nextPage: ->
    current_page = @get("current_page") + 1
    @setCurrentPage(current_page)

  toggleAnnotatingMode: ->
    if @get("mode") is "view"
      @set(mode: "annotate")
    else
      @set(mode: "view")

  getMode: ->
    @get("mode")

  setMode: (mode) ->
    @set("mode": mode)

  validate: (attrs) ->
    if typeof attrs.current_page != "undefined"
      return "not a number" if isNaN(attrs.current_page)
      return "exceeded max" unless 1 <= attrs.current_page <= @getTotalPages()
      attrs.current_page = parseInt(attrs.current_page)
    return
