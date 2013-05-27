class DV.AnnotationPopupView extends Backbone.View
  template: JST['document_viewer/templates/annotation_popup']

  events:
    "click .reply":        "onReply"
    "click .show_replies": "onShowReplies"

  initialize: (options) ->
    @dv = options.dv

  render: ->
    html = @template({
      author:  @model.get('author_label')
      moderated_comment: @model.get('moderated_comment')
      date:    DV.DateFormat.format(@model.get('created_at'))
      annotationsAllowed: @dv.areAnnotationsAllowed()
    })
    $(@el).hide()
    $(@el).html(html)

  onReply: ->
    @dv.onReplyCallback().apply(@, [@model.get("id"), @model.get("comment")])
    false

  onShowReplies: ->
    @dv.onShowRepliesCallback().apply(@, [@model.get("id")])
    false

  hide: ->
    $(@el).css(display: 'none')

  show: (where) ->
    $(@el).css
      "z-index":   99
      display:  'inline-block'
      position: 'absolute'
      width:    @dv.documentWidth()
      left:     where.left
      top:      where.top

  height: ->
    $(@el).height()
