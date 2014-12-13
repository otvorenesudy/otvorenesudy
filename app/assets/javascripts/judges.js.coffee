class window.JudgeChart
  data:
    labels: ['Počet reštančných', 'Vybavenosť', 'Kapacita vybavovať', 'Reštančné z nevybavených', 'Počet nevybavených', 'Frekvencia odvolaní', 'Potvrdené rozhodnutia ', 'Zmenené / zrušené z celku'],
    datasets: [{
      label: "Sudca",
      fillColor: "rgba(81,163,81,0.2)",
      strokeColor: "rgba(81,163,81,1)",
      pointColor: "rgba(81,163,81,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "#fff",
      pointHighlightStroke: "rgba(220,220,220,1)",
    }, {
      label: "Priemer SR",
      fillColor: "rgba(151,187,205,0.2)",
      strokeColor: "rgba(151,187,205,1)",
      pointColor: "rgba(151,187,205,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "#fff",
      pointHighlightStroke: "rgba(151,187,205,1)",
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

    @chart = new Chart($('#judge-indicators-chart .chart').get(0).getContext('2d')).Radar(@data, @options)

    $('#judge-indicators-chart .legend').append(@chart.generateLegend())
