module IndicatorsHelper
  def assigned_agendas_indicator(indicators)
    value = indicators['S4'].gsub(/([^\s]+ agenda|žiadnej agende väčšinovo)/) do |match|
      content = <<-CON
        #{t 'judges.indicators.basic.agenda.civil'} &ndash; #{indicators['S4a']}<br/>
        #{t 'judges.indicators.basic.agenda.business'} &ndash; #{indicators['S4b']}<br/>
        #{t 'judges.indicators.basic.agenda.childcare'} &ndash; #{indicators['S4c']}<br/>
        #{t 'judges.indicators.basic.agenda.criminal'} &ndash; #{indicators['S4d']}<br/>
      CON

      popover_tag match, content, title: t('judges.indicators.basic.assigned_agendas'), trigger: 'hover'
    end

    # TODO translate
    "Sudcovi #{value}".html_safe
  end

  def decided_agendas_indicator(indicators)
    value = indicators['S5'].gsub(/([^\s]+ agende|žiadnej agende väčšinovo)/) do |match|
      content = <<-CON
        #{t 'judges.indicators.basic.agenda.civil'} &ndash; #{indicators['S5a']}<br/>
        #{t 'judges.indicators.basic.agenda.business'} &ndash; #{indicators['S5b']}<br/>
        #{t 'judges.indicators.basic.agenda.childcare'} &ndash; #{indicators['S5c']}<br/>
        #{t 'judges.indicators.basic.agenda.criminal'} &ndash; #{indicators['S5d']}<br/>
      CON

      popover_tag match, content, title: t('judges.indicators.basic.decided_agendas'), trigger: 'hover'
    end

    # TODO translate
    "Sudca #{value}".html_safe
  end

  # TODO rm - unused?
  # def abjuration_rate_indicator(indicators, options = {})
  #   tooltip_tag(indicators['S9'], 'Indikátor nie je presný. O rozhodnutiach sudcu rozhoduje odvolací súd nie nevyhnutne v rovnakom roku. Čím viac dát o práci sudcu máme, tým je indikátor presnejší.')
  # end
  #
  # def cancellation_rate_indicator(indicators, options = {})
  #   tooltip_tag(indicators['S10'], 'Indikátor nie je presný. O rozhodnutiach sudcu rozhoduje odvolací súd nie nevyhnutne v rovnakom roku. Čím viac dát o práci sudcu máme, tým je indikátor presnejší.')
  # end
  #
  # def average_proceeding_duration_indicator(indicators, options = {})
  #   tooltip_tag(indicators['S11'], 'Indikátor je vypočítaný ako podiel medzi nevybavenými vecami na konci roka a rozhodnutými vecami počas roka 2013. Čím je toto číslo nižšie, tým schopnejší je sudca vybavovať včas to, čo mu prichádza.')
  # end

  def indicators_chart(judge, options = {})
    colors = %w(9b59b6 1abc9c 3498db f1c40f e74c3c e67e22 2ecc71)
    judges = [judge] + options.fetch(:others, [])
    locals = { colors: judges.size.times.map { |i| colors[i % colors.size] }, judges: judges }
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
