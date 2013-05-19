$(document).ready ->

  # Define styles
  $.extend $.tablesorter.themes.bootstrap,
      table      : 'table table-striped'
      header     : 'bootstrap-header'
      footerRow  : ''
      footerCells: ''
      icons      : ''
      sortNone   : 'bootstrap-icon-unsorted',
      sortAsc    : 'icon-chevron-up',
      sortDesc   : 'icon-chevron-down',
      active     : ''
      hover      : ''
      filterRow  : ''
      even       : ''
      odd        : ''

  # TODO: check if all characters are considered
  $.extend($.tablesorter.characterEquivalents, 
    'a': 'áä'
    'A': 'ÁÄ'
    'c': 'č'
    'C': 'Ç'
    'd': 'ď'
    'D': 'Ď'
    'e': 'é'
    'E': 'É'
    'i': 'í'
    'I': 'Í'
    'l': 'ľ'
    'L': 'Ľ'
    'n': 'ň'
    'N': 'Ň'
    'o': 'óô'
    'O': 'ÓÔ'
    'r': 'ŕ'
    'R': 'Ŕ'
    's': 'š'
    'S': 'Š'
    't': 'ť'
    'T': 'Ť'
    'u': 'ú'
    'U': 'Ú'
    'y': 'ý'
    'Y': 'Ý'
    'z': 'ž'
    'Z': 'Ž'
  )

  window.initializeTablesorter = (tables) ->
    $('table').tablesorter
      theme: 'bootstrap'
      headerTemplate : '{content} {icon}'
      widgets: ["uitheme", 'resizeable']
      sortLocaleCompare: true
      textExtraction: (node, table, column) ->
        columns = $(table).find("tr:nth(1) td").length
        row     = $(node).closest('tr').index()
        result  = ""

        while column < columns
          value = $(table).find("tbody tr:nth(#{row}) td:nth(#{column})").attr('data-value')
          result += "#{value}," if value?
          column++

        result

    $('table').bind 'sortEnd', ->
      fixes()
