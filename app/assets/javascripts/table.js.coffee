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

  # TODO: use for every table?
  window.initializeTablesorter = (tables) ->
    $('table').tablesorter
      theme: 'bootstrap'
      headerTemplate : '{content} {icon}'
      widgets: ["uitheme", 'resizeable']

    $('table').bind 'sortEnd', ->
      fixes()
