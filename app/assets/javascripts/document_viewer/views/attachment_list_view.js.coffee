class DV.AttachmentListView extends Backbone.View
  template: JST['document_viewer/templates/attachments_list']

  events:
    "click a": "attachmentClicked"

  initialize: (options) ->
    @dv = options.dv
    @attachments = options.attachments
    @parent = options.parent

  render: ->
    @overlay = $('<div>')
    @overlay.css(position: 'absolute', top: 0, left: 0, width: '100%', height: '100%', 'z-index': 2)
    @overlay.addClass('_dv_overlay')
    @overlay.click =>
      @hide()
      false
    $(@el).html(@template(attachments: @attachments))
    $(@parent).before(@overlay)
    $(@parent).before(@el)

  show: =>
    @overlay.show()
    $(@el).show()

  hide: =>
    @overlay.hide()
    $(@el).hide()

  toggle: =>
    @overlay.toggle()
    $(@el).toggle()

  attachmentClicked: (e) ->
    attachmentNumber = $(e.target).data('attachment-number')
    @dv.setCurrent(document_number: attachmentNumber)
    @hide()
    false
