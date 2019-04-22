module IndicatorsHelper
  def assigned_agendas_indicator_2013(indicators)
    value = indicators['S4'].gsub(/([^\s]+ agenda|žiadnej agende väčšinovo)/) do |match|
      content = <<-CON
        #{t 'judges.indicators_2013.basic.agenda.civil'} &ndash; #{indicators['S4a']}<br/>
        #{t 'judges.indicators_2013.basic.agenda.business'} &ndash; #{indicators['S4b']}<br/>
        #{t 'judges.indicators_2013.basic.agenda.childcare'} &ndash; #{indicators['S4c']}<br/>
        #{t 'judges.indicators_2013.basic.agenda.criminal'} &ndash; #{indicators['S4d']}<br/>
      CON

      popover_tag match, content, title: t('judges.indicators_2013.basic.assigned_agendas'), trigger: 'hover'
    end

    # TODO translate
    "Sudcovi #{value}".html_safe
  end

  def decided_agendas_indicator_2013(indicators)
    value = indicators['S5'].gsub(/([^\s]+ agende|žiadnej agende väčšinovo)/) do |match|
      content = <<-CON
        #{t 'judges.indicators_2013.basic.agenda.civil'} &ndash; #{indicators['S5a']}<br/>
        #{t 'judges.indicators_2013.basic.agenda.business'} &ndash; #{indicators['S5b']}<br/>
        #{t 'judges.indicators_2013.basic.agenda.childcare'} &ndash; #{indicators['S5c']}<br/>
        #{t 'judges.indicators_2013.basic.agenda.criminal'} &ndash; #{indicators['S5d']}<br/>
      CON

      popover_tag match, content, title: t('judges.indicators_2013.basic.decided_agendas'), trigger: 'hover'
    end

    # TODO translate
    "Sudca #{value}".html_safe
  end

  def assigned_agendas_indicator_2015(indicators)
    content = <<-CON
      #{t 'judges.indicators_2013.basic.agenda.civil'} &ndash; #{indicators['C.assigned.agenda']}<br/>
      #{t 'judges.indicators_2013.basic.agenda.business'} &ndash; #{indicators['Cb.assigned.agenda']}<br/>
      #{t 'judges.indicators_2013.basic.agenda.childcare'} &ndash; #{indicators['P.assigned.agenda']}<br/>
      #{t 'judges.indicators_2013.basic.agenda.criminal'} &ndash; #{indicators['Trest.assigned.agenda']}<br/>
    CON

    if indicators['assigned.agenda.dominant'].to_s != '0'
      result = I18n.t('judges.indicators_2015.basic.dominant_assigned_agenda') +
      popover_tag(I18n.t("judges.indicators_2015.basic.assigned_agenda.#{indicators['assigned.agenda.dominant']}"), content, title: t('judges.indicators_2013.basic.assigned_agendas'), trigger: 'hover')
    else
      result = I18n.t('judges.indicators_2015.basic.no_dominant_assigned_agenda_1') +
      popover_tag(I18n.t('judges.indicators_2015.basic.no_dominant_assigned_agenda_2'), content, title: t('judges.indicators_2013.basic.assigned_agendas'), trigger: 'hover')
    end

    result.html_safe
  end

  def decided_agendas_indicator_2015(indicators)
    if indicators['decided.agenda.dominant'].to_s != '0'
      I18n.t('judges.indicators_2015.basic.dominant_decided_agenda') +
      I18n.t("judges.indicators_2015.basic.decided_agenda.#{indicators['decided.agenda.dominant']}")
    else
      I18n.t('judges.indicators_2015.basic.no_dominant_decided_agenda')
    end
  end

  def indicators_chart(judge, options = {})
    colors = %w(9b59b6 1abc9c 3498db f1c40f e74c3c e67e22 2ecc71)
    judges = [judge] + options.fetch(:others, [])
    locals = { colors: judges.size.times.map { |i| colors[i % colors.size] }, judges: judges }.merge(options.slice(:indicators_repository, :year))
    options = options.slice(:width, :height).merge(class: 'chart-content')

    content_for :scripts do
      content_tag :script, type: 'text/javascript' do
        render(partial: 'judges/indicators/chart/handler', formats: :js, locals: locals).html_safe
      end
    end

    content_tag :div, content_tag(:canvas, nil, options), class: 'chart'
  end

  def link_to_indicators_name_facet(facet, result, options = {})
    link_to_indicators_terms_facet facet, result, options.merge(count: false)
  end

  def link_to_indicators_terms_facet(facet, result, options = {})
    path = -> (other) { "#{judge_path params.merge other}#indicators-chart" }
    link_to_facet_value facet, result, result.value, options.merge(path: path)
  end
end
