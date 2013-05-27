class DV.CommentView extends Backbone.View
  template: JST['document_viewer/templates/comment']

  render: ->
    html = @template(@model.attributes)
    $(@el).html(html)
