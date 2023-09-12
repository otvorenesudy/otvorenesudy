# TODO update to chartjs > 2.0 to be able to use multiline lables to save canvas space (especially for 2013 labels)

class window.Indicators2021Chart
  constructor: (data) ->
    @colors = ["#f16c4f", "#00aeef", "#e19e41", "#73be1e", "#8392ac"]
    @data = Object.keys(data).map((key, i) => { label: key, value: data[key], color: @colors[i] })

  build: ->
    container = $("#indicators-chart-2021")
    @chart = new Chart(container.find('.chart-canvas').get(0).getContext('2d')).PolarArea(
      @data,
      {
        scaleShowLabels: false,
        legendTemplate: """
          <ul class="list-inline mt-4">
            <% for (var i = 0; i < segments.length; i++) { %>
              <li class="list-inline-item">
                <span class="d-inline-block align-top mr-2 my-1" style="width: 16px; height: 16px; background: <%= segments[i].fillColor %>"></span><%= segments[i].label %>
              </li>
            <% } %>
          </ul>
        """
      }
    )
    container.find('.chart-legend').append(@chart.generateLegend())
