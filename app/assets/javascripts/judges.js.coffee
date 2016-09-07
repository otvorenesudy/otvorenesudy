# TODO review
# TODO translate

class window.JudgeChart
  data:
    labels: ['Počet reštančných',
             'Vybavenosť',
             'Kapacita vybavovať',
             'Reštančné z nevybavených',
             'Počet nevybavených',
             'Frekvencia odvolaní',
             'Potvrdené rozhodnutia',
             'Zmenené alebo zrušené z celku'],

    datasets: [{
      label: "Sudca",
      fillColor: "rgba(81,163,81,0.2)",
      strokeColor: "rgba(81,163,81,1)",
      pointColor: "rgba(81,163,81,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "#fff",
      pointHighlightStroke: "rgba(220,220,220,1)",
    }, {
      label: "Priemer",
      fillColor: "rgba(151,187,205,0.2)",
      strokeColor: "rgba(151,187,205,1)",
      pointColor: "rgba(151,187,205,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "#fff",
      pointHighlightStroke: "rgba(151,187,205,1)",
    }, {
      label: "Maximum",
      fillColor: "rgba(255,255,255,0.0)",
      strokeColor: "rgba(0,20,0, 0.2)",
      pointColor: "rgba(0,0,0,0.6)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "#fff",
      pointHighlightStroke: "rgba(151,187,205,1)",
      data: [10, 10, 10, 10, 10, 10, 10, 10]
    }]

  options:
    legendTemplate : '
      <ul class="legend unstyled">
        <% for (var i=0; i<datasets.length; i++) {%>
          <li class="title">
            <span class="color-sample" style="background-color: <%= datasets[i].pointColor %>"></span>
            <%= datasets[i].label %>
          </li>
        <% } %>
      </ul>
    '
  constructor: (name, judge, avarage) ->
    @data.datasets[0].label = name
    @data.datasets[0].data  = judge
    @data.datasets[1].data  = avarage

  build: ->
    @chart = new Chart($('#judge-indicators-chart .chart').get(0).getContext('2d')).Radar(@data, @options)

    $('#judge-indicators-chart .legend').append(@chart.generateLegend())

  addDataset: (judge, data, color) ->
    @data.datasets.push(
      label: judge,
      fillColor: "rgba(#{color[0]},#{color[1]},#{color[2]},0.2)",
      strokeColor: "rgba(#{color[0]},#{color[1]},#{color[2]},1)",
      pointColor: "rgba(#{color[0]},#{color[1]},#{color[2]},1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "#fff",
      pointHighlightStroke: "rgba(151,187,205,1)",
      data: data
    )
