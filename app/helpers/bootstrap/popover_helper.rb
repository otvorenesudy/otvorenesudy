# frozen_string_literal: true

module Bootstrap
  module PopoverHelper
    def popover_tag(name, content, options = {})
      options[:placement] ||= 'top'

      bootstrap = options.extract!(:delay, :placement, :trigger, :title).compact.transform_keys { |key| :"bs_#{key}" }
      data = bootstrap.merge(bs_toggle: 'popover', bs_content: content, controller: 'popover',
                             action: 'popover#prevent')

      link_to name, '#', options.deep_merge(data:, tabindex: 0, role: 'button')
    end
  end
end
