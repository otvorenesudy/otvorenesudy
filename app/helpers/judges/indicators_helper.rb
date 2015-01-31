module Judges
  module IndicatorsHelper
    def assigned_agendas_indicator(indicators, options = {})
      value = indicators['S4'].gsub(/([^\s]+ agenda|žiadnej agende väčšinovo)/) do |match|
        content = <<-EOF
          Občianska &ndash; #{indicators['S4a']} <br/>
          Obchodná &ndash; #{indicators['S4b']} <br/>
          Poručenská &ndash; #{indicators['S4c']} <br/>
          Trestná &ndash; #{indicators['S4d']}\n <br/>
        EOF

        popover_tag(match, content, title: 'Prideľované agendy', trigger: :hover)
      end

      "Sudcovi #{value}".html_safe
    end

    def decrees_agendas_indicator(indicators, options = {})
      value = indicators['S5'].gsub(/([^\s]+ agende|žiadnej agende väčšinovo)/) do |match|
        content = <<-EOF
          Občianska &ndash; #{indicators['S5a']} <br/>
          Obchodná &ndash; #{indicators['S5b']} <br/>
          Poručenská &ndash; #{indicators['S5c']} <br/>
          Trestná &ndash; #{indicators['S5d']}\n <br/>
        EOF

        popover_tag(match, content, title: 'Rozhodované agendy', trigger: :hover)
      end

      "Sudca #{value}".html_safe
    end

    def abjuration_rate_indicator(indicators, options = {})
      tooltip_tag(indicators['S9'], 'Indikátor nie je presný. O rozhodnutiach sudcu rozhoduje odvolací súd nie nevyhnutne v rovnakom roku. Čím viac dát o práci sudcu máme, tým je indikátor presnejší.')
    end

    def cancellation_rate_indicator(indicators, options = {})
      tooltip_tag(indicators['S10'], 'Indikátor nie je presný. O rozhodnutiach sudcu rozhoduje odvolací súd nie nevyhnutne v rovnakom roku. Čím viac dát o práci sudcu máme, tým je indikátor presnejší.')
    end

    def average_proceeding_length_indicator(indicators, options = {})
      tooltip_tag(indicators['S11'], 'Indikátor je vypočítaný ako podiel medzi nevybavenými vecami na konci roka a rozhodnutými vecami počas roka 2013. Čím je toto číslo nižšie, tým schopnejší je sudca vybavovať včas to, čo mu prichádza.')
    end

    def link_to_indicators_terms_facet(facet, result, options = {})
      path = ->(*args) do
        judge_path(*([params[:id]] + args))
      end

      link_to_facet_value(facet, result, result.value, options.merge(path: path))
    end

    def link_to_add_indicators_facet(facet, result, options = {})
      icon_link_to :plus, nil, judge_path(params[:id], result.add_params), class: :add
    end

    def link_to_remove_indicators_facet(facet, result, options = {})
      icon_link_to :remove, nil, judge_path(params[:id], result.remove_params), class: :remove
    end
  end
end
