$(document).ready ->
  class window.Search
    constructor: (selector, model) ->
      $("#{selector} .facet .facet-title[data-toggle=\"collapse\"]").click ->
        name      = $(this).closest('.facet').attr('data-id')
        collapsed = $(this).hasClass('collapsed') == false

        $.get '/search/collapse', { model: model, facet: name, collapsed: collapsed }

      new Suggest(selector)

  class window.Suggest
    constructor: (selector) ->
      @.register(input) for input in $("#{selector} .facet .facet-suggest")

    register: (input) ->
        name = $(input).attr('data-id')
        path = $(input).attr('data-path')

        $(input).autocomplete
          minLength: 0
          source: (request, response) ->
            content = $(input).closest('.facet-content')
            results = $(content).find('.facet-results')

            $(results).find('.facet-link').click (e) -> e.preventDefault()
            $(results).find('.facet-link').addClass('disabled')

            terms = []

            for i in $(input)
              terms.push($(i).val())

            $.ajax
              url: path
              type: 'GET'
              data:
                facet: name
                term: terms.join(' ')
              success: (html) ->
                $(results).html(html)

                fixes()
