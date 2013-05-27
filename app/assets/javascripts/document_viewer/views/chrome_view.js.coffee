class DV.ChromeView extends Backbone.View
  template: JST['document_viewer/templates/chrome']
  template_mini: JST['document_viewer/templates/chrome_mini']
  template_notification: JST['document_viewer/templates/notification']

  initialize: (options) ->
    @dv = options.dv

  render: ->
    $(@el).css(width: @dv.getWidth())

    if @dv.hasAttachments()
      @renderChrome()
    else
      @renderNotification()

  renderChrome: ->
    if @dv.getWidth() > 600
      $(@el).html(@template())
    else
      $(@el).html(@template_mini())

    new DV.NavigationView(dv: @dv, el: @$('._dv_page_nav')).render()
    new DV.DocumentView(dv: @dv, el: @$('._dv_document')).render()
    new DV.DocumentControlView(dv: @dv, el: @$('._dv_document_control')).render()
    new DV.ZoomView(dv: @dv, el: @$('._dv_zoom')).render() if @dv.zoomAllowed()
    new DV.DocumentSelectorView(dv: @dv, el: @$('#_dv_attachment_selector')).render()
    new DV.CommentListView(dv: @dv, el: @$('._dv_comments')).render() if @dv.commentListAllowed()

  renderNotification: ->
    $(@el).html(@template_notification(height: @dv.getHeight()))
