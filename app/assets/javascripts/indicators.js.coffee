class window.JudgeChart
  options:
    animation: false,
    responsive: true,

    angleLineColor: "#eceeef",
    datasetStrokeWidth: 2,
    pointLabelFontFamily: "Open Sans",
    pointLabelFontStyle: "300",
    pointLabelFontSize: 12.8,
    pointLabelFontColor: "#55595c",
    pointDotRadius: 0,

    tooltipFillColor: "#373a3c",
    tooltipFontFamily: "Open Sans",
    tooltipFontSize: 12.8,
    tooltipFontStyle: "300",
    tooltipFontColor: "#fff",
    tooltipTitleFontFamily: "Open Sans",
    tooltipTitleFontSize: 12.8,
    tooltipTitleFontStyle: "300",
    tooltipTitleFontColor: "#fff",
    tooltipXPadding: 8,
    tooltipYPadding: 8,
    tooltipCaretSize: 0,
    tooltipCornerRadius: 0,
    tooltipXOffset: 10,
    legendTemplate: '
      <ul class="list-unstyled">
        <% for (var i = 0; i < datasets.length; i ++) { %>
          <li><span style="background: <%= datasets[i].pointColor %>"></span><%= datasets[i].label %></li>
        <% } %>
      </ul>
    '

  getData: () ->
    2013:
      labels: [
        'Počet reštančných',
        'Vybavenosť',
        'Kapacita vybavovať',
        'Reštančné z nevybavených',
        'Počet nevybavených',
        'Frekvencia odvolaní',
        'Potvrdené rozhodnutia',
        'Zmenené alebo zrušené z celku'
      ],

      datasets: [{
        label: "Maximum",
        fillColor: "transparent",
        strokeColor: "transparent",
        pointColor: "#ecf0f1",
        data: [10, 10, 10, 10, 10, 10, 10, 10]
      }, {
        label: "Priemer",
        fillColor: "transparent",
        strokeColor: "#bdc3c7",
        pointColor: "#bdc3c7",
      }]

    2015:
      labels: [
        'Vybavenosť',
        'Reštančné z nevybavených',
        'Kapacita vybavovať',
        'Potvrdené rozhodnutia'
      ],

      datasets: [{
        label: "Maximum",
        fillColor: "transparent",
        strokeColor: "transparent",
        pointColor: "#ecf0f1",
        data: [10, 10, 10, 10]
      }, {
        label: "Priemer",
        fillColor: "transparent",
        strokeColor: "#bdc3c7",
        pointColor: "#bdc3c7",
      }]

  constructor: (year, average) ->
    @year = year
    @data = @getData()[year]
    @data.datasets[1].data = average

  push: (judge, data, color) ->
    @data.datasets.push(
      label: judge,
      fillColor: "transparent",
      strokeColor: color,
      pointColor: color,
      data: data
    )

  build: ->
    container = $("#indicators-chart-#{@year}")
    @chart = new Chart(container.find('.chart-content').get(0).getContext('2d')).Radar(@data, @options)
    container.find('.chart-legend-content').append(@chart.generateLegend())
