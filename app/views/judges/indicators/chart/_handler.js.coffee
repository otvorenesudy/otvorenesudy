window.judgeChart = new JudgeChart(<%= raw Judge::Indicators.numerical_average.values.to_json %>)

<% judges.zip(colors).each do |judge, color| %>
judgeChart.push("<%= raw judge.name %>", <%= raw judge.indicators.numerical.to_hash.values[2..9].to_json %>, <%= raw "##{color}".to_json %>)
<% end %>

judgeChart.build()

$(document).ready ->
  new Search.Suggest('#indicators-chart').register()
  new Search.Suggest('#indicators-facets').register()
