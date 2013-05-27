class DV.NavigationView extends Backbone.View
  events:
    "click ._dv_prev_page": "previousPage",
    "click ._dv_next_page": "nextPage",
    "keypress ._dv_current_page": "jumpToPageOnEnter"

  render: =>
    $('._dv_current_page').val(@dv.getCurrentPageNumber())
    $('._dv_total_pages').html(@dv.getTotalPages())

  initialize: (options) ->
    @dv = options.dv
    @dv.bind("document:change", @render, @)
    @dv.bind("document:switch", @render, @)
    @dv.bind("document:error", @render, @)
    @dv.bind("change:mode", @adjustVisibility, @)
    @input = $('._dv_current_page')

  previousPage: ->
    @dv.previousPage()
    false

  nextPage: ->
    @dv.nextPage()
    false

  jumpToPageOnEnter: (e) ->
    if e.which is 13
      current_page = @input.val()
      @input.blur()
      current_page = @dv.setCurrent(page_number: current_page)

  adjustVisibility: ->
    if @dv.showsComments()
      $(@el).hide()
    else
      $(@el).show()

