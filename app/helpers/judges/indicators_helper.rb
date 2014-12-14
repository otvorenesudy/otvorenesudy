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
      value = indicators['S5'].gsub(/([^\s]+ agenda|žiadnej agende väčšinovo)/) do |match|
        content = <<-EOF
          Občianska &ndash; #{indicators['S5a']} <br/>
          Obchodná &ndash; #{indicators['S5b']} <br/>
          Poručenská &ndash; #{indicators['S5c']} <br/>
          Trestná &ndash; #{indicators['S5d']}\n <br/>
        EOF

        popover_tag(match, content, title: 'Rozhodované agendy', trigger: :hover)
      end

      "Sudcovi #{value}".html_safe
    end
  end
end
