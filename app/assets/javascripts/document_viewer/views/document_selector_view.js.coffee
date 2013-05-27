class DV.DocumentSelectorView extends Backbone.View
  template: JST['document_viewer/templates/attachment_selector']

  initialize: (options) ->
    @dv = options.dv
    @dv.bind("change", @render, @)
    @selector = new DV.AttachmentListView(dv: @dv, attachments: @dv.documents, parent: $('._dv_document'))
    @selector.render()
    @selector.hide()

  events:
    "click .attachment_selector": "attachmentSelectorClicked"

  render: ->
    $(@el).html(@template(attachments_count: @dv.documents.size(), attachment_title: @dv.getCurrentDocumentName()))

  attachmentSelectorClicked: ->
    @selector.toggle()
