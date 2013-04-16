$(document).ready ->
    class OpenCourts.SearchView extends Backbone.AbstractView
      @include Util.Logger
      @include Util.Initializer
      @include Util.View.Finder
      @include Util.View.List
      @include Util.View.Slider
      @include Util.View.Suggest
      @include Util.View.Loading
      @include Util.View.ScrollTo

      @include OpenCourts.SearchViewTemplates

      el:                '#search-view'
      result_list:       '#search-results'
      result_info:       '#search-info'
      result_pagination: '#search-pagination'

      events:
        'click a[href="#"]'                 : 'onClickButton'
        'click #fulltext button'            : 'onSubmitFulltext'
        'change #fulltext input'            : 'onSubmitFulltext'
        'click #search-panel ul li a'       : 'onSelectListItem'
        'click #search-panel ul li .add'    : 'onAddListItem'
        'click #search-panel ul li .remove' : 'onRemoveListItem'
        'click .pagination ul li a'         : 'onChangePage'

      initialize: (options) ->
        @.log 'Initializing ...'

        @.setup(options)

        @.log 'Binding model.'

        @model.bind 'change', (obj) =>
          @.onModelChange(obj)

        @.suggestList 'judges', query: => @model.query()

        @.suggestList 'court', query: => @model.query()

        @.log 'Initialization done.'

        @.onModelChange() unless Backbone.history.getHash().length > 0

      onModelChange: (obj) ->
        @.log "Model changed. (model=#{@.inspect obj})"

        @.onSearch reload: true, =>

          @.updateFulltext(@model.getFulltext())

          for entity, value of @model.facets
            @.updateList(entity)

      updateFulltext: (value) ->
        $('#fulltext input').val(value)

      updateList: (name) ->
        @.log "Updating list: #{name}"

        @.refreshListValues(name)

        list = @.list(name)

        for value in @model.get name
          label = @model.label(name, value)

          # TODO: consider not showing facet count for selected items
          @.prependListItem(list, label, value, @model.facet(name, value))
          @.selectListItem(list, value)

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

      onSubmitFulltext: ->
        value = $('#fulltext input').val()

        @model.setFulltext(value)

      onChangePage: (event) ->
        event.preventDefault()

        value = @.findValue(event.target, 'href').match(/&page=\d+/)?[0]

        value = parseInt(value?.match(/\d+$/)?[0])

        @.log "Setting page to #{value}"

        @model.setPage(value)

      onSelectListItem: (event) ->
        list  = @.listByItem(event.target)
        value = @.listItemValue(event.target)
        attr  = @.listEntity(list)

        @model.add attr, value, multi: false

      onAddListItem: (event) ->
        list  = @.listByItem(event.target)
        value = @.listItemValue(event.target)
        attr  = @.listEntity(list)

        @model.add attr, value, multi: true

      onRemoveListItem: (event) ->
        list  = @.listByItem(event.target)
        attr  = @.listEntity(list)
        value = @.listItemValue(event.target)

        @model.remove attr, value

      onChangeSlider: (event, ui, el, format) ->
        @.log "Changing slider ... (element=#{el}, values=#{ui.values})"

        el = $(@el).find("##{el}-slider-bar")

        if format?
          format(el, ui.values)
        else
          el.html("#{ui.values[0]} &ndash; #{ui.values[1]}")

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
