Util.View.List =
  listID: (name) ->
    "#{name}-list"

  listSelector: (param) ->
    "##{@.listID(param)}"

  list: (param) ->
    return param unless typeof(param) is 'string'
    $(@.listSelector(param))

  listShow: (list) ->
    @.list(list).show()

  listHideAll: ->
    $('ul[id$=-list]').hide()

  listEntity: (list) ->
    @.list(list).attr('id').replace(/(#|-list)/g, '')

  listFoldState: (list, value) ->
    if value?
      @.list(list).find('.fold').attr('data-state', value)
    else
      @.list(list).find('.fold').attr('data-state')

  listUnfold: (list, options) ->
    @.log "Unfolding list #{@.list(list).attr('id')}"

    @.list(list).append(@template['list_items_unfold'])
    @.list(list).find("li:gt(#{options.visible})").show()

    @.listFoldState(list, 'unfolded')

  listFold: (list, options) ->
    @.log "Folding list #{@.list(list).attr('id')}"

    @.list(list).append(@template['list_items_fold'])
    @.list(list).find("li:gt(#{options.visible})").hide()

    @.listFoldState(list, 'folded')

  listToggle: (list, options) ->
    state = @.listFoldState(list)

    state = if state == 'folded' then 'unfolded' else 'folded'

    options.state = state

    @.listCollapse(list, options)

  listCollapse: (list, options) ->
    elements = @.list(list).find('li')
    state    = options.state or @.listFoldState(list)

    @.list(list).find('a.fold').remove()

    unless state?
      @.listFold(list, options) if elements.length > options.visible
    else
      if state == 'unfolded'
        @.listUnfold(list, options)
      else
        @.listFold(list, options)

  item: (target) ->
    $(target).parent()

  listItemValue: (target) ->
    @.item(target).attr('data-value')

  closestList: (target) ->
    $(target).closest('[id$=-list]')

  listByItem: (target) ->
    @.closestList(@.item(target))

  findListItem: (list, value) ->
    @.log "Find list value: #{value}"

    @.list(list).find("li[data-value='#{value}']")

  selectListItem: (list, value) ->
    item = @.findListItem(list, value)

    item.addClass('selected').append(@template['remove_list_item'](value: value))

  unselectListItem: (list, value) ->
    @.findListItem(@.list(list), value).find('a.remove').remove()

  listHasItem: (list, value) ->
    @.log "Checking existence of value: #{value}"

    @.findListItem(@.list(list), value).length ? true : false

  addListItem: (list, label, value, facet) ->
    @.log "Appending list item (label=#{label}, value=#{value}, facet=#{facet})"

    # TODO: create separate method to handle template generation for prepend and
    # append 
    @.list(list).append(@template['list_item'](label: label ?= value, value: value, facet: facet ?= ''))

  prependListItem: (list, label, value, facet) ->
    @.log "Prepending list item (label=#{label}, value=#{value}, facet=#{facet})"

    @.findListItem(list, value).remove()

    @.list(list).prepend(@template['list_item'](label: label ?= value, value: value, facet: facet ?= ''))

  clearList: (list, options = {}) ->
    selector = if options.selected then 'li:not(.selected)' else 'li'
    selector = "#{selector}, a.fold"

    @.log "Clearing list ... (list=#{@.inspect list}, selector=#{@.inspect selector}, options=#{@.inspect options})"

    $(@.list(list)).find(selector).remove()

  findOrCreateListItem: (list, label, value, facet) ->
    list = @.list(list)

    if @.listHasItem(list, value)
      @.findListItem(list, value)
    else
      @.addListItem(list, label, value, facet)
