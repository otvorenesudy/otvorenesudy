class DV.PageView extends Backbone.View
  tagName:   "div"
  className: "page"

  initialize: (options) ->
    @dv = options.dv
    @dv.bind("change:zoom", @render, @)
    @model.bind("change", @render, @)
    @setupStyles()

  setupStyles: ->
    $(@el).css(width: @dv.getWidth(), height: @dv.getHeight(), position: 'relative')

  render: =>
    if @model.get("type") is "scan"
      if @model.get("hidden")
        $(@el).html("<div class='blank_page'>Načítavam..</div>")
      else
        width = @dv.documentWidth()
        height = @dv.documentHeight()
        $(@el).css(width: "#{width}px", height: "#{height}px")
        @image = $("<img src='#{@model.get("scanUrl")}' style='border: none; margin: 0; padding: 0; position: absolute;' />") unless @image
        @image.css(height: "#{height}px", width: "#{width}px")
        $(@el).empty().append(@image)
        $(@el).css(overflow: 'hidden')
        @setupAreaSelector()
        @renderAnnotations()
    else
      if @model.get("hidden")
        $(@el).html("<div class='blank_page'>Načítavam..</div>")
      else
        $(@el).html("#{@model.getText()}")
        $(@el).css(overflow: 'auto', height: @dv.getHeight(), width: @dv.getWidth())
    @el

  setupAreaSelector: ->
    if @dv.getMode() is "view"
      @areaSelector?.remove()
    else
      @areaSelector?.remove()
      @areaSelector = $('img', @el).imgAreaSelect(handles: true, instance: true, parent: '._dv_document', zIndex: 2, onSelectEnd: @areaSelected, onSelectTerminated: @selectionCanceled)

  offsetTop: ->
    @el.offsetTop

  offsetBottom: ->
    @el.offsetTop + @el.offsetHeight

  scrollBottom: ->
    return 0 unless @el.offsetParent
    @el.offsetHeight - (@el.offsetTop - @el.offsetParent.scrollTop)

  isWithinViewport: (viewport_scroll_top) ->
    Math.abs(@offsetTop() - viewport_scroll_top) < 200

  isVisible: (viewport) ->
    @offsetTop() < viewport.bottom and not(@offsetBottom() < viewport.top)

  areaSelected: (img, selection) =>
    @newAnnotationView?.remove()
    @newAnnotationView = new DV.NewAnnotationView(model: new DV.Comment(), parentView: @, dv: @dv)
    @newAnnotationView.bind("created", @onAnnotationCreated)
    @newAnnotationView.render(area: selection)

  selectionCanceled: (img) =>
    @newAnnotationView.remove()

  renderAnnotations: ->
    @model.annotations.each (annotation) =>
      @renderAnnotation(annotation)

  renderAnnotation: (annotation) =>
    annotationView = new DV.AnnotationView(model: annotation, dv: @dv, parentView: @).render()
    $(@el).prepend(annotationView)

  onAnnotationCreated: (annotation) =>
    annotation.set(page_number: @model.getNumber())
    annotation.set(attachment_number: @model.attachment.getNumber())
    annotation.set(author_label: @dv.getCurrentUser())
    annotation.set(created_at: new Date())
    annotation.save()
    @model.annotations.add(annotation)
    @areaSelector.cancelSelection()
    @dv.setMode("view")
