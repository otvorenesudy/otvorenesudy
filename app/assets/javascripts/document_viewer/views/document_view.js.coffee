class DV.DocumentView extends Backbone.View

  autoScrollEnabled: true

  events:
    "mousedown" : "startDragScroll",
    "mouseup"   : "stopDragScroll",
    "mousemove" : "dragScroll",
    "mouseleave": "stopDragScroll",
    "scroll"    : "documentScrolled"

  documents: {}
  pageViews: {}

  initialize: (options) ->
    @dv = options.dv
    @dv.bind("document:change:current_page", @autoScrollToCurrentPage, @)
    @dv.bind("document:switch", @documentSwitched, @)
    @dv.bind("document:change:mode", @documentModeChanged, @)
    @dv.bind("document:change:type", @documentModeChanged, @)
    @dv.bind("change:mode", @documentVisibilityChanged, @)
    @dv.bind("change:zoom", @alignPageToViewPort, @)
    @setupStyles()
    @reloadPageViews()
    @setupDocumentMode()

  setupStyles: ->
    $(@el).css(overflow: 'hidden', position: 'relative', height: @dv.getHeight(), width: @dv.getWidth() + parseInt($(@el).css('leftBorderWidth'), 10))

  startDragScroll: (e) =>
    return unless @draggingAllowed()
    if e.button is 0
      $(@el).css("cursor": DV.Browser.cursor('grabbing'))
      @dragging = e
      e.preventDefault()
      e.stopPropagation()

  stopDragScroll: (e) =>
    return unless @draggingAllowed()
    $(@el).css("cursor": DV.Browser.cursor('grab'))
    @dragging = false

  dragScroll: (e) =>
    return unless @draggingAllowed()
    if @dragging
      @elDOM().scrollTop = @elDOM().scrollTop + (@dragging.clientY - e.clientY)
      @elDOM().scrollLeft = @elDOM().scrollLeft + (@dragging.clientX - e.clientX)
      @dragging = e
      e.preventDefault()
      e.stopPropagation()

  draggingAllowed: ->
    @dv.viewing() and @dv.showsScan()

  alignPageToViewPort: ->
    width = @dv.getWidth()
    if @elDOM().scrollLeft + width > @dv.documentWidth()
      @elDOM().scrollLeft = @dv.documentWidth() - width

  elDOM: ->
    $(@el)[0]

  autoScrollToCurrentPage: =>
    if @autoScrollEnabled
      currentPageNumber = @dv.getCurrentPageNumber()
      currentPage = @pageViews[currentPageNumber]
      @elDOM().scrollTop = currentPage.offsetTop()

  reloadPageViews: ->
    if @documents[@dv.getCurrentDocumentNumber()]
      @pageViews = @documents[@dv.getCurrentDocumentNumber()]
    else
      @pageViews = {}
      @dv.getPages().each (page) => @pageViews[page.getNumber()] = new DV.PageView(dv: @dv, model: page)
      @documents[@dv.getCurrentDocumentNumber()] = @pageViews

    $(@el).empty()
    _(@pageViews).each (pageView) => $(@el).append(pageView.render())
    @hideAndShowVisiblePages()

  render: =>
    _(@pageViews).invoke("render")
    @hideAndShowVisiblePages()

  documentScrolled: ->
    @syncCurrentPageNumber()
    @hideAndShowVisiblePages()

  syncCurrentPageNumber: ->
    pageInViewPort = _.detect(@pageViews, (pageView) => pageView.isWithinViewport(@elDOM().scrollTop))
    if pageInViewPort
      @withDisabledAutoscroll =>
        @dv.setCurrent(page_number: pageInViewPort.model.getNumber())

  hideAndShowVisiblePages: ->
    viewport = {}
    viewport.bottom = @elDOM().scrollTop + @elDOM().offsetHeight
    viewport.top    = @elDOM().scrollTop

    visible = _(@pageViews).select((pageView) => pageView.isVisible(viewport))
    hidden  = _(@pageViews).difference(visible)
    _(visible).each (pageView) -> pageView.model.show()
    _(hidden).each  (pageView) -> pageView.model.hide()

  withDisabledAutoscroll: (action) ->
    @autoScrollEnabled = false
    action()
    @autoScrollEnabled = true

  documentModeChanged: ->
    @setupDocumentMode()
    @autoScrollToCurrentPage() if @dv.showsFulltext()
    @render()

  documentSwitched: ->
    @reloadPageViews()
    @setupDocumentMode()

  setupDocumentMode: ->
    $(@el).css("cursor": "crosshair") if @dv.annotating()
    $(@el).css("cursor": DV.Browser.cursor('grab')) if @draggingAllowed()
    $(@el).css("cursor": "text") if @dv.viewing() and @dv.showsFulltext()

  documentVisibilityChanged: ->
    if @dv.showsComments()
      $(@el).hide()
    else
      $(@el).show()
