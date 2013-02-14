$(document).ready ->
    class OpenCourts.SearchView extends Backbone.AbstractView
      @include Util.Logger
      @include Util.Initializer
      @include Util.View.Finder
      @include Util.View.List
      @include Util.View.Slider
      @include Util.View.Autocomplete
      @include Util.View.Loading
      @include Util.View.ScrollTo
 
      @include OpenCourts.SearchViewTemplates
      
      el:                '#search-view'
      result_list:       '#search-results'
      result_info:       '#search-info'
      result_pagination: '#search-pagination'
 
      events:
        'click a[href="#"]'                 : 'onClickButton'
        'click #category button'            : 'onChangeCategory'
        'click #search-panel ul li a'       : 'onClickListItem'
        'click #search-panel ul li .remove' : 'onRemoveListItem'
        'click .pagination ul li a'         : 'onChangePage'

      initialize: (options) ->
        @.log 'Initializing ...'

        @.setup(options)

        @.log 'Binding model.'

        @model.bind 'change', (obj) =>
          @.onModelChange(obj)

        @model.page = 1

        @.autocompleteList 'judges', query: => @model.toJSON()

        @.autocompleteList 'court', query: => @model.toJSON()

        @.log 'Initialization done.'
          
        @.onModelChange()

      onModelChange: (obj) ->
        @.log "Model changed. (model=#{@.inspect obj})"

        @.onSearch reload: true, =>
          @.updateCategory()
          @.updateList('judges')
          @.updateList('court')
          @.updateList('date')

      updateCategory: ->
        @.log "Updating category: #{@model.getCategory()}"

        @.findElementByValue('#category', @model.getCategory()).addClass('active')

      updateList: (name) ->
        @.log "Updating list: #{name}"

        @.refreshListValues(name)

        list = @.list(name)

        for value in @model.get name
          label = @model.label(name, value)

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
        false

      onChangeCategory: (event) ->
        value = @.findValue(event.target, 'data-value')

        @model.setCategory(value)

      onChangePage: (event) ->
        event.preventDefault()
        
        value = @.findValue(event.target, 'href').match(/&page=\d+$/)?[0]

        value = parseInt(value?.match(/\d+$/)?[0])
        
        @.log "Setting page to #{value}"

        @model.setPage(value)

      onClickListItem: (event) ->
        list  = @.listByItem(event.target)
        value = @.listItemValue(event.target)
        attr  = @.listEntity(list)

        @model.add attr, value, multi: attr.pluralized()
        
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

      onQuickSearch: (event) ->
        @.advancedSearchClose()

        value = $(event.target).val()

        @.log "Starting quicksearch ... (value='#{value}')"

        if value
          #@.loading(@movie_list, reload: true)
          
          @model.find value, (response) =>
            @.log 'Response recieved.'

            #@.updateMovieList(@movie_list, response.data, reload: true)
        else
          @.onModelChange(@model)


      onSearch: (options, callback) ->
        @.log "Searching ... (options=#{@.inspect options})"
        
        @.loading @result_list, options

        $("#{@result_pagination}, #{@result_info}").empty()

        @model.search (response) =>
          @.log 'Search was successful.'

          if response
            @.updateResults response
          
          @.unloading @result_list

          callback?()
