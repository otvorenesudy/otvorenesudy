# frozen_string_literal: true

module Bootstrap
  module TooltipHelper
    def tooltip_tag(name, title, options = {})
      bootstrap = options.extract!(:delay, :placement, :trigger).compact.transform_keys { |key| :"bs_#{key}" }
      data = bootstrap.merge(bs_toggle: 'tooltip', bs_title: title, controller: 'tooltip', action: 'tooltip#prevent')

      link_to name, '#', options.deep_merge(data:, tabindex: 0, role: 'button')
    end
  end
end
