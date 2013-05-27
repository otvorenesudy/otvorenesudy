class DV.CommentListView extends Backbone.View
  initialize: (options) ->
    $(@el).hide()
    @dv = options.dv
    @dv.bind("change:mode", @updateVisibility, @)

  render: ->
    $(@el).css(height: @dv.getHeight())
    _(@dv.getComments()).each (comment) =>
      commentEl = $('<div>')
      $(@el).append(commentEl)

      if comment.isAnonymous()
        new DV.AnonymousCommentView(el: commentEl, model: comment).render()
      else
        new DV.CommentView(el: commentEl, model: comment).render()

  updateVisibility: ->
    if @dv.showsComments()
      $(@el).show()
    else
      $(@el).hide()



