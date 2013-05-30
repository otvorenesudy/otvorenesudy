class DV.DocumentControlView extends Backbone.View
  events:
    "click ._dv_document_scan":      "showScan"
    "click ._dv_document_fulltext":  "showFulltext"
    "click ._dv_document_comments":  "showComments"
    "click ._dv_add_annotation":     "toggleAnnotatingMode"
    "click ._dv_pin_annotations":    "toggleAnnotations"
    "change ._dv_search input":      "onSearch"
    "click  ._dv_search a":          "onSearch"
    "click  ._dv_search_results a":  "onClickSearchResult"

  initialize: (options) ->
    @dv = options.dv
    @prepareContent()
    @removeDisallowedButtons()
    @dv.bind("document:change:type", @disableOrEnableAnnotatingButton, @)
    @dv.bind("document:switch", @documentSwitched, @)
    @dv.bind("document:change:mode", @updateDocumentMode, @)
    @dv.bind("change:mode", @updateDocumentMode, @)
    @documentSwitched()

  prepareContent: ->
    @scanButton = $('._dv_document_scan')
    @fulltextButton = $('._dv_document_fulltext')
    @annotationButton = $('._dv_add_annotation')
    @commentsButton = $('._dv_document_comments')
    @instructions = $('.instructions')
    @pinAnnotations = $('._dv_pin_annotations')
    @annotationTools = $('._dv_annotation_tools')
    @searchInput     = $('._dv_search input')
    @searchResults   = $('._dv_search_results')
    @hiddenControls  = $('._dv_document_control.hidden')

    @pinAnnotations.html('Zobraziť')
    $('._dv_annotations_count').html("(#{@dv.getNumberOfAnnotations()})")
    @commentsButton.html("#{@commentsButton.html()} (#{@dv.getNumberOfComments()})")

    @searchInput.val(@dv.query)

    @onSearch() if @searchInput.val().length > 0

  showScan: ->
    @dv.showScan()
    false

  showFulltext: ->
    @dv.showFulltext()
    false

  showComments: ->
    @dv.showComments()
    false

  toggleAnnotatingMode: ->
    @dv.toggleAnnotatingMode()

    false

  toggleAnnotations: ->
    @dv.pinAnnotations()
    if @dv.areAnnotationsPinned()
      @pinAnnotations.html('Skryť')
    else
      @pinAnnotations.html('Zobraziť')
    false

  removeDisallowedButtons: ->
    @annotationButton.remove() unless @dv.areAnnotationsAllowed()
    @commentsButton.remove() unless @dv.commentListAllowed()
    @annotationButton.remove() unless @dv.userLoggedIn()

  disableOrEnableAnnotatingButton: ->
    if @dv.showsFulltext()
      @scanButton.removeClass("active")
      @fulltextButton.addClass("active")
      @commentsButton.removeClass("active")
      @annotationButton.hide()
    if @dv.showsScan()
      @fulltextButton.removeClass("active")
      @scanButton.addClass("active")
      @commentsButton.removeClass("active")
      @annotationButton.show()

  updateDocumentMode: ->
    if @dv.annotating()
      @annotationButton.addClass("active")
      @annotationTools.hide()
      @instructions.show()
    if @dv.viewing()
      @annotationButton.removeClass("active")
      @annotationTools.show()
      @instructions.hide()
    if @dv.showsComments()
      @scanButton.removeClass("active")
      @fulltextButton.removeClass("active")
      @commentsButton.addClass("active")
      @annotationTools.show()
      @instructions.hide()

  onSearch: ->
    q = @searchInput.val()

    html = @dv.search q, (html) =>
      @searchResults.html(html)
      @hiddenControls.show()

  onClickSearchResult: ->
    $('html, body').scrollTop(@hiddenControls.position().top)

  documentSwitched: ->
    @disableOrEnableAnnotatingButton()
    @updateDocumentMode()
