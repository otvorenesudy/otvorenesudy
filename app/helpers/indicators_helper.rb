# frozen_string_literal: true

module IndicatorsHelper
  AGENDAS = %w[civil business childcare criminal].freeze

  # The agenda phrase of the 2013 statistics ("civilnej agenda"), explained by a popover of the counts per agenda.
  AGENDA_2013 = /([^\s]+ agenda|žiadnej agende väčšinovo)/
  DECIDED_AGENDA_2013 = /([^\s]+ agende|žiadnej agende väčšinovo)/

  def assigned_agendas_indicator_2013(indicators)
    counts = indicators.values_at('S4a', 'S4b', 'S4c', 'S4d')

    safe_join([t('judges.indicators_2013.basic.assigned_agendas_subject'), ' ',
               agendas_indicator(indicators['S4'], AGENDA_2013, counts,
                                 t('judges.indicators_2013.basic.assigned_agendas'))])
  end

  def decided_agendas_indicator_2013(indicators)
    counts = indicators.values_at('S5a', 'S5b', 'S5c', 'S5d')

    safe_join([t('judges.indicators_2013.basic.decided_agendas_subject'), ' ',
               agendas_indicator(indicators['S5'], DECIDED_AGENDA_2013, counts,
                                 t('judges.indicators_2013.basic.decided_agendas'))])
  end

  def assigned_agendas_indicator_2015(indicators)
    counts = indicators.values_at('C.assigned.agenda', 'Cb.assigned.agenda', 'P.assigned.agenda',
                                  'Trest.assigned.agenda')
    dominant = indicators['assigned.agenda.dominant'].to_s
    options = { title: t('judges.indicators_2013.basic.assigned_agendas'), trigger: 'hover' }

    if dominant == '0'
      return safe_join([t('judges.indicators_2015.basic.no_dominant_assigned_agenda_1'),
                        popover_tag(t('judges.indicators_2015.basic.no_dominant_assigned_agenda_2'),
                                    agendas_popover_content(counts), options)])
    end

    safe_join([t('judges.indicators_2015.basic.dominant_assigned_agenda'),
               popover_tag(t("judges.indicators_2015.basic.assigned_agenda.#{dominant}"),
                           agendas_popover_content(counts), options)])
  end

  def decided_agendas_indicator_2015(indicators)
    dominant = indicators['decided.agenda.dominant'].to_s

    return t('judges.indicators_2015.basic.no_dominant_decided_agenda') if dominant == '0'

    t('judges.indicators_2015.basic.dominant_decided_agenda') +
      t("judges.indicators_2015.basic.decided_agenda.#{dominant}")
  end

  # The judge, the judges compared with, and the average of the year's scores; the first is the average.
  def indicators_chart_series(judge, others, dataset)
    average = { label: t('judges.indicators.chart.average'), data: dataset.numerical_average.values }
    judges = [judge, *others].map { |item| { label: item.name, data: dataset.numerical_values_for(item) } }

    [average, *judges]
  end

  # The data of an element enclosing a chart and its legend: the indicators-chart controller draws the chart, each
  # series in the color of its swatch in the legend.
  def indicators_chart_data(type:, labels:, series:)
    {
      controller: 'indicators-chart',
      indicators_chart_type_value: type,
      indicators_chart_labels_value: labels.to_json,
      indicators_chart_series_value: series.to_json
    }
  end

  def indicators_chart_tag(labels)
    tag.div(class: 'chart') do
      tag.canvas(class: 'chart-canvas', data: { indicators_chart_target: 'canvas' }, 'aria-label': labels.join(', '),
                 role: 'img')
    end
  end

  # A radar's legend lists its series (the average first) in a column, a polar area's its segments in a line.
  def indicators_chart_legend_tag(labels, polar: false)
    items = labels.each_with_index.map do |label, index|
      tag.li(class: polar ? 'list-inline-item' : 'facet-item') do
        color = polar ? "chart-segment-#{index}" : "chart-series-#{index}"

        safe_join([tag.span(class: ['chart-swatch', color], data: { indicators_chart_target: 'swatch' }), label])
      end
    end

    tag.div(class: 'chart-legend') { tag.ul(safe_join(items), class: polar ? 'list-inline mt-4' : 'facet-list') }
  end

  def link_to_indicators_name_facet(facet, result, options = {})
    link_to_indicators_terms_facet facet, result, options.merge(count: false)
  end

  # Links of the comparison facets stay on the judge's page, in the tab of the year.
  def link_to_indicators_terms_facet(facet, result, options = {})
    year = facet.params.find { |key, value| key.to_s.start_with?('indicators') && value }&.first
    path = ->(query) { judge_path(params[:id], query.merge(anchor: year&.to_s&.dasherize)) }

    link_to_facet_value facet, result, result.value, options.merge(path:)
  end

  private

  def agendas_indicator(text, pattern, counts, title)
    parts = text.to_s.split(pattern).each_with_index.map do |part, index|
      index.odd? ? popover_tag(part, agendas_popover_content(counts), title:, trigger: 'hover') : part
    end

    safe_join(parts)
  end

  def agendas_popover_content(counts)
    lines = AGENDAS.zip(counts).map do |agenda, count|
      safe_join([t("judges.indicators_2013.basic.agenda.#{agenda}"), count], ' – ')
    end

    safe_join(lines, tag.br).to_str
  end
end
