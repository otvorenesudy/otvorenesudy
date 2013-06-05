$(document).ready ->
    class OpenCourts.SearchView extends Backbone.AbstractView
      @include Logger
      @include Initializer
      @include View.Finder
      @include View.List
      @include View.Suggest
      @include View.Loading
      @include View.ScrollTo

      el:                '#search-view'
      result_list:       '#search-results'
      result_info:       '#search-info'
      result_pagination: '#search-pagination'

      events:
        'click a[href="#"]'                   : 'onClickButton'
        'click [data-id="q"] button'          : 'onSubmitQuery'
        'change [data-id="q"] input'          : 'onSubmitQuery'
        'click #search-panel ul li a'         : 'onSelectListItem'
        'click #search-panel ul li .add'      : 'onAddListItem'
        'click #search-panel ul li .remove'   : 'onRemoveListItem'
        'click .pagination ul li a'           : 'onChangePage'
        'click #search-panel ul a.fold'       : 'onToggleFold'
        'click input[data-id="historical"]'   : 'onClickHistorical'
        'change #sort'                        : 'onChangeSort'
        'click  #order'                       : 'onClickOrder'

      template:
        list_item:          JST['open_courts/search/templates/list_item']
        list_items_fold:    JST['open_courts/search/templates/list_items_fold']
        list_items_unfold:  JST['open_courts/search/templates/list_items_unfold']
        remove_list_item:   JST['open_courts/search/templates/remove_list_item']
        spinner:            JST['open_courts/search/templates/spinner']
        empty_list_message: JST['open_courts/search/templates/empty_list_message']

      initialize: (options) ->
        @.log 'Initializing ...'

        @.setup(options)

        @.log 'Binding model.'

        @model.bind 'change', (obj) =>
          @.onModelChange(obj)

        @facetInputs        = $('.facet input')
        @queryInput         = $('[data-id="q"] input')
        @queryButton        = $('[data-id="q"] button')
        @historicalCheckbox = $('[data-id="historical"]')
        @sortSelectbox      = $('#sort')
        @orderRadiobox      = $('#order')
        @orderButton        = $('#order button')

        @.setupListSuggest()

        @.log 'Initialization done.'

        @.onModelChange() unless Backbone.history.getHash().length > 0

      onModelChange: (obj) ->
        @.log "Model changed. (model=#{@.inspect obj})"

        @.onSearch reload: true, =>

          @.updateHistorical() if @model.getHistorical?
          @.updateQuery(@model.getQuery()) if @model.getQuery?
          @.updateSort(@model.getSort())
          @.updateOrder(@model.getOrder())

          for entity, value of @model.facets
            @.updateList(entity)
            @.listCollapse(entity, visible: 10)

      updateQuery: (value) ->
        @queryInput.val(value)

      # TODO: refactor to updateBooleanFacet
      updateHistorical: (value) ->
        @historicalCheckbox.prop('checked', @model.getHistorical())

      updateSort: (value) ->
        @sortSelectbox.val(value)

      updateOrder: (value) ->
        @orderButton.removeClass('active')
        @orderRadiobox.find("button[data-order='#{value}']").addClass('active')

      updateList: (name) ->
        @.log "Updating list: #{name}"

        @.refreshListValues(name)

        list = @.list(name)

        for value in @model.get name
          label = @model.label(name, value)

          @.prependListItem(list, label, value, @model.facet(name, value))
          @.selectListItem(list, value)

        list.html(@template.empty_list_message) if @.listEmpty(list)

      refreshListValues: (name) ->
        @.log "Refreshing: #{name}"

        list = @.list(name)
        values = @model.values name

        @.clearList(list)

        if values
          @.log "Refreshing ... (values=#{values})"

          for value in values
            label = @model.label(name, value)

            @.addListItem(list, label, value, @model.facet(name, value)) unless @.listHasItem(list, value)


      fixes: ->
        @.log 'Applying fixes ...'

        fixes?()

      updateResults: (data) ->
        $(@result_list).html(data.results) # no worries, synchronious
        $(@result_pagination).html(data.pagination)
        $(@result_info).html(data.info)
        @.fixes()

      onClickButton: (event) ->
        event.preventDefault()

      onSubmitQuery: ->
        value = @queryInput.val()

        @model.setPage 1, silent: true

        @model.setQuery(value)

      onChangePage: (event) ->
        event.preventDefault()

        value = $(event.target).attr('href').match(/&page=\d+/)?[0]

        value = parseInt(value?.match(/\d+/)?[0])

        @.log "Setting page to #{value}"

        @model.setPage(value)

      onSelectListItem: (event) ->
        list  = @.listByItem(event.target)
        value = @.listItemValue(event.target)
        attr  = @.listEntity(list)

        @model.setPage 1, silent: true

        @model.add attr, value, multi: false

      onAddListItem: (event) ->
        list  = @.listByItem(event.target)
        value = @.listItemValue(event.target)
        attr  = @.listEntity(list)

        @model.setPage 1, silent: true

        @model.add attr, value, multi: true

      onRemoveListItem: (event) ->
        list  = @.listByItem(event.target)
        attr  = @.listEntity(list)
        value = @.listItemValue(event.target)

        @model.setPage 1, silent: true

        @model.remove attr, value

      onToggleFold: (event) ->
        list = @.closestList(event.target)

        @.listToggle(list, visible: Config.facets.max_visible, manual: true)

      # TODO: refactor to onClickBooleanFacet
      onClickHistorical: (event) ->
        @model.setPage 1, silent: true
        @model.setHistorical(event.target.checked)

      onChangeSort: (event) ->
        value = $(event.target).val()

        @.log "Setting sort to #{value}"

        @model.setSort(value)

      onClickOrder: (event) ->
        value = @.findValue(event.target, 'data-order')

        @.log "Setting order to #{value}"

        @model.setOrder(value)

      setupListSuggest: ->
        @facetInputs.each (i, el) =>
          @.suggestList el, $(el).attr('data-id'), query: => @model.query()

      onSearch: (options, callback) ->
        @.log "Searching ... (options=#{@.inspect options})"

        @.loading @result_list, options

        $("#{@result_pagination}, #{@result_info}").empty()

        @model.search (response) =>
          @.log 'Running response callback.'

          if response.error
            $(@result_list).html(response.html)
          else
            @.updateResults response

          @.unloading @result_list

          callback?()
