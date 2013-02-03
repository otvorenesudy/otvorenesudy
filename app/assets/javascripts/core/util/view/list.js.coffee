Util.View.List =
  listSelector: (param) ->
    "##{param}-list"

  list: (name) ->
    $(@.listSelector(name))

  listEntity: (list) ->
    $(list).attr('id').replace(/(#|-list)/g, '')

  item: (target) ->
    $(target).parent()
  
  listItemValue: (target) ->
    @.item(target).attr('data-value')

  listByItem: (target) ->
    @.item(target).parent()

  findListItem: (list, value) ->
    @.log "Find list value: #{value}"

    list.find("li[data-value='#{value}']")

  selectListItem: (list, value) ->
    item = @.findListItem(list, value)

    item.addClass('selected').append(@template['remove_list_item'](value: value))

  unselectListItem: (list, value) ->
    @.findListItem(list, value).find('a.remove').remove()

  listHasItem: (list, value) ->
    @.log "Checking existence of value: #{value}"

    @.findListItem(list, value).length ? true : false

  addListItem: (list, value, facet) ->
    @.log "Adding list item (value=#{value}, facet=#{facet})"

    $(list).append(@template['list_item'](value: value, facet: facet))

  clearList: (list) ->
    $(list).find('li').remove()
