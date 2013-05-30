class DV.Viewer extends Backbone.Model

  initialize: (options) ->
    @set(current_user: options.currentUser)
    @set(on_reply: options.onReply)
    @set(on_show_replies: options.onShowReplies)
    @set(width: options.size.width)
    @set(height: options.size.height)
    @set(annotationsAllowed: options.annotationsAllowed)
    @set(mode: 'document')
    @set(zoom: 1)
    @set(zoomAllowed: options.zoom)
    @set(commentListAllowed: options.commentList)
    @documents = new DV.Documents(options.documents)
    @documents.each (document) =>
      document.bind("all", (eventName) => @trigger("document:#{eventName}"))
    @set(comments: options.comments)

    @query  = options.search.query
    @search = options.search.callback

    methods = ['previousPage', 'getCurrentDocumentNumber': 'getNumber', 'nextPage', 'getPages', 'getTotalPages', 'getCurrentPageNumber', 'getType', 'toggleAnnotatingMode', 'getMode', 'setMode']
    delegate(methods, {from: @, to: @getCurrentDocument})

  defaults:
    current_document_number: 1

  isDisplayed: (document) ->
    @getCurrentDocument() == document

  getCurrentDocument: =>
    @documents.at(@get("current_document_number") - 1)

  getCurrentDocumentName: ->
    @getCurrentDocument().getName()

  setCurrent: (options) ->
    if options.document_number and @get("current_document_number") != parseInt(options.document_number)
      @getCurrentDocument().setMode("view")
      @set(current_document_number: options.document_number)
      @trigger("document:switch")

    if options.page_number
      @getCurrentDocument().setCurrentPageNumber(options.page_number)
    else
      @getCurrentDocument().setCurrentPageNumber(1)

    if options.annotation
      @getCurrentDocument().getCurrentPage().showAnnotation(parseInt(options.annotation))

  showScan: ->
    @set(mode: 'document')
    @getCurrentDocument().showScan()

  showFulltext: ->
    @set(mode: 'document')
    @getCurrentDocument().showFulltext()
    @getCurrentDocument().setMode("view")

  showComments: ->
    @set(mode: 'comments')

  showsComments: ->
    @get("mode") == 'comments'

  showsDocument: ->
    @get("mode") == 'document'

  showsFulltext: ->
    @getType() is "fulltext"

  showsScan: ->
    @getType() is "scan"

  validate: (options) ->
    if typeof options.current_document_number != "undefined"
      options.current_document_number = parseInt(options.current_document_number)
    return

  getCurrentUser: ->
    @get("current_user")

  onReplyCallback: ->
    @get("on_reply")

  onShowRepliesCallback: ->
    @get("on_show_replies")

  getComments: ->
    @get("comments")

  getWidth: ->
    @get("width")

  getHeight: ->
    @get("height")

  annotating: ->
    @getMode() is "annotate"

  viewing: ->
    @getMode() is "view"

  areAnnotationsAllowed: ->
    @get("annotationsAllowed")

  documentWidth: ->
    @get("width") * @get("zoom")

  documentHeight: ->
    @get("height") * @get("zoom")

  zoomIn: ->
    newZoom = @get("zoom") + 0.4
    newZoom = 2.2 if newZoom > 2.2
    @set(zoom: newZoom)

  zoomOut: ->
    newZoom = @get("zoom") - 0.4
    newZoom = 1 if newZoom < 1
    @set(zoom: newZoom)

  zoomAllowed: ->
    @get('zoomAllowed')

  commentListAllowed: ->
    @get('commentListAllowed')

  getNumberOfAnnotations: ->
    annotations = _(@get("comments")).filter (comment) ->
      comment.isAnnotation()
    annotations.length

  getNumberOfComments: ->
    @get("comments").length

  pinAnnotations: ->
    if @areAnnotationsPinned()
      @set(annotationsPinned: false)
    else
      @set(annotationsPinned: true)

  areAnnotationsPinned: ->
    @get('annotationsPinned')

  userLoggedIn: ->
    @get("current_user") != ""

  hasAttachments: ->
    @documents.length > 0

  search: (q) ->
    @search(q)
