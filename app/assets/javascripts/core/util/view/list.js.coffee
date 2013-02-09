Util.View.List =
  listSelector: (param) ->
    "##{param}-list"

  list: (param) ->
    return param unless typeof(param) is 'string'
    $(@.listSelector(param))

  listEntity: (list) ->
    @.list(list).attr('id').replace(/(#|-list)/g, '')

  item: (target) ->
    $(target).parent()
  
  listItemValue: (target) ->
    @.item(target).attr('data-value')

  listByItem: (target) ->
    @.item(target).parent()

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

  addListItem: (list, value, facet) ->
    @.log "Adding list item (value=#{value}, facet=#{facet})"
    
    $(@.list(list)).append(@template['list_item'](value: value, facet: facet ?= ''))

  addListItem: (list, value, facet) ->
    @.log "Adding list item (value=#{value}, facet=#{facet})"

    @.list(list).append(@template['list_item'](value: value, facet: facet ?= ''))

  prependListItem: (list, value, facet) ->
    @.log "Prepending list item (value=#{value}, facet=#{facet})"

    @.findListItem(list, value).remove()

    @.list(list).prepend(@template['list_item'](value: value, facet: facet ?= ''))

  clearList: (list, options = {}) ->
    selector = if options.selected then 'li:not(.selected)' else 'li'
    
    @.log "Clearing list ... (list=#{@.inspect list}, selector=#{@.inspect selector}, options=#{@.inspect options})"

    $(@.list(list)).find(selector).remove()

  findOrCreateListItem: (list, value, facet) ->
    list = @.list(list)

    if @.listHasItem(list, value)
      @.findListItem(list, value)
    else
      @.addListItem(list, value, facet)
