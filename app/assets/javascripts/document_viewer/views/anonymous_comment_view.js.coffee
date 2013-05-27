class DV.AnonymousCommentView extends Backbone.View
  template: JST['document_viewer/templates/anonymous_comment']

  render: ->
    html = @template(@model.attributes)
    $(@el).html(html)
