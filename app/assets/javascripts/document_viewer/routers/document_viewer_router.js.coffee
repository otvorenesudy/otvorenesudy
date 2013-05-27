class DV.DocumentViewerRouter extends Backbone.Router
  initialize: (options) ->
    @dv = options.dv
    @dv.bind("document:change", @updatePageRoute, @)
    @dv.bind("document:switch", @updatePageRoute, @)

  routes:
    "document/:document/page/:page/annotation/:annotation": "goToDocumentPageAnnotation"
    "document/:document/page/:page": "goToDocumentPage"
    "": "index"

  goToDocumentPage: (document, page) ->
    @dv.setCurrent(document_number: document, page_number: page)
    @updatePageRoute()

  goToDocumentPageAnnotation: (document, page, annotation) ->
    @dv.setCurrent(document_number: document, page_number: page, annotation: annotation)

  index: ->
    @dv.setCurrent(document_number: 1, page_number: 1)

  updatePageRoute: ->
    @navigate("document/#{@dv.getCurrentDocumentNumber()}/page/#{@dv.getCurrentPageNumber()}")
