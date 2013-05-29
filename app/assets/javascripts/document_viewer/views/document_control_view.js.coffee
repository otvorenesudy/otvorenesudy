class DV.DocumentControlView extends Backbone.View
  events:
    "click ._dv_document_scan":      "showScan"
    "click ._dv_document_fulltext":  "showFulltext"
    "click ._dv_document_comments":  "showComments"
    "click ._dv_add_annotation":     "toggleAnnotatingMode"
    "click ._dv_pin_annotations":    "toggleAnnotations"

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

    @pinAnnotations.html('Zobraziť')
    $('._dv_annotations_count').html("(#{@dv.getNumberOfAnnotations()})")
    @commentsButton.html("#{@commentsButton.html()} (#{@dv.getNumberOfComments()})")

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

  documentSwitched: ->
    @disableOrEnableAnnotatingButton()
    @updateDocumentMode()
