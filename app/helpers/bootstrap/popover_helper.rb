module Bootstrap
  module PopoverHelper
    def popover_tag(name, content, options = {})
      options[:placement] ||= 'top'
      data = options.extract!(*%i(delay placement trigger)).select { |_, v| v }
      options.deep_merge! data: data.merge(content: content, toggle: 'popover'), tabindex: -1
      link_to name, '#', options
    end
  end
end
