# TODO rm?

$(document).ready ->

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

  $.extend $.tablesorter.themes.bootstrap,
      table      : 'table table-striped'
      header     : ''
      footerRow  : ''
      footerCells: ''
      icons      : ''
      sortNone   : 'icon-sort'
      sortAsc    : 'icon-sort-up'
      sortDesc   : 'icon-sort-down'
      active     : ''
      hover      : ''
      filterRow  : ''
      even       : ''
      odd        : ''

  $('table[data-sortable="true"]').tablesorter
    theme:         'bootstrap'
    tableClass:    'table'
    cssAsc:        'table-header-asc'
    cssDesc:       'table-header-desc'
    cssChildRow:   'table-children'
    cssHeader:     'table-header'
    cssHeaderRow:  'table-headers'
    cssIcon:       'table-icon'
    cssInfoBlock:  'table-info'
    cssProcessing: 'table-processing'

    headerTemplate: '{content} <span>{icon}</span>'
    widgets: ['uitheme']

    sortLocaleCompare: true
    textExtraction: (node, table, column) -> $.trim($(node).attr('data-value') or $(node).text())

  $('table').bind 'sortEnd', ->
    fixes()
