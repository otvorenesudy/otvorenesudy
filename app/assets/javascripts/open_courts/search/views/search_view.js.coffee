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
      
      el:  "#search-view"
 
      events:
        'click a[href="#"]'                   : 'onClickButton'
        'click #type button'                  : 'onChangeType'
        'click #search-panel ul li a'         : 'onClickListItem'
        'click #search-panel ul li .remove'   : 'onRemoveListItem'

      initialize: (options) ->
        @.log 'Initializing ...'

        @.setup(options)

        @.log 'Binding model.'

        @model.bind 'change', (obj) =>
          @.onModelChange(obj)

        @model.page = 1

        @.autocompleteList 'judges'

        @.log 'Initialization done.'
          
        @.onModelChange(@model)

      onModelChange: (obj) ->
        @.log "Model changed. (model=#{@.inspect obj})"

        @.onSearch reload: true, scrollTo: true, more: true, =>
          @.updateType()
          @.updateList('judges')
        
      findButton: (selector, value) ->
        $(selector).find("*[data-value='#{value}']")

      updateType: ->
        @.log "Updating type: #{@model.getType()}"
        @.findButton('#type', @model.getType()).addClass('active')

      updateList: (name) ->
        @.log "Updating list: #{name}"

        @.refreshListValues(name)

        list = @.list(name)

        for value in @model.get name
          @.addListItem(list, value, @model.facet(name, value)) unless @.listHasItem(list, value)
          @.selectListItem(list, value)
  
      refreshListValues: (name) ->
        @.log "Refreshing: #{name}"

        list = @.list(name)
        values = @model.values name

        @.clearList(list)
        
        if values
          @.log "Refreshing ... (values=#{values})"

          for value in values
            @.addListItem(list, value, @model.facet(name, value)) unless @.listHasItem(list, value)


      onClickButton: (event) ->
        false

      onChangeType: (event) ->
        value = @.findValue(event.target, 'data-value')

        @model.setType(value)

      onClickListItem: (event) ->
        list  = @.listByItem(event.target)
        value = @.listItemValue(event.target)
        attr  = @.listEntity(list)

        @model.add attr, value
        
      onRemoveListItem: (event) ->
        list  = @.listByItem(event.target)
        attr  = @.listEntity(list)
        value = @.listItemValue(event.target)

        @model.remove attr, value

      onLoadMore: (event) ->
        @model.page += 1
        
        @.log "Loading more ... (page=#{@model.page})"

        @.onSearch reload: false, scrollTo: true, more: true

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
        
        #@.loading @movie_list, options

        @model.search (response) =>
          @.log 'Search was successful.'

          if response.data
            #@.updateMovieList @movie_list, response.data,
            #  reload: options.reload,
            #  more:   options.more unless response.last_page
          else
            @.noMoreResults() if options.reload

          #@.unloading @movie_list

          callback?()

      noMoreResults: ->
        $(@movie_list).append(@template['no_more_results'])
