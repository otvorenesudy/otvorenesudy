# TODO update to chartjs > 2.0 to be able to use multiline lables to save canvas space (especially for 2013 labels)

class window.JudgeChart
  options:
    animation: false,
    responsive: true,

    angleLineColor: "#d1dee8",
    scaleLineColor: "#d1dee8",

    pointLabelFontColor: "#1b325f",
    pointLabelFontFamily: "Ubuntu",
    pointLabelFontStyle: "300",
    pointLabelFontSize: 12.8,
    pointDotRadius: 0,

    showTooltips: false,

    legendTemplate: """
      <div class="facet-results">
        <ul class="facet-list">
          <% for (var i = 1; i < datasets.length; i ++) { %>
            <li class="facet-item">
              <span class="d-inline-block align-top mr-2 my-1" style="width: 16px; height: 16px; background: <%= datasets[i].strokeColor %>"></span><%= datasets[i].label %>
            </li>
          <% } %>
        </ul>
      </div>
    """

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
        data: [10, 10, 10, 10, 10, 10, 10, 10]
      }, {
        label: "Priemer",
        fillColor: "transparent",
        strokeColor: "#8392ac",
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
        data: [10, 10, 10, 10]
      }, {
        label: "Priemer",
        fillColor: "transparent",
        strokeColor: "#8392ac",
      }]

    2017:
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
        data: [10, 10, 10, 10]
      }, {
        label: "Priemer",
        fillColor: "transparent",
        strokeColor: "#8392ac",
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
      data: data
    )

  build: ->
    container = $("#indicators-chart-#{@year}")
    @chart = new Chart(container.find('.chart-canvas').get(0).getContext('2d')).Radar(@data, @options)
    container.find('.chart-legend').append(@chart.generateLegend())
