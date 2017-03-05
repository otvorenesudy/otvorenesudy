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
    table:       'table'
    header:      ''
    footerRow:   ''
    footerCells: ''
    icons:       ''
    sortNone:    ''
    sortAsc:     'ion-ios-arrow-thin-up'
    sortDesc:    'ion-ios-arrow-thin-down'
    active:      ''
    hover:       ''
    filterRow:   ''
    even:        ''
    odd:         ''

  $('table[data-sortable="true"]').tablesorter
    theme:         'bootstrap'
    tableClass:    'table'

    headerTemplate: '{content}{icon}'
    widgets: ['uitheme']

    sortLocaleCompare: true
    textExtraction: (node, table, column) -> $.trim($(node).attr('data-value') or $(node).text())

  $('table').bind 'sortEnd', ->
    fixes()
