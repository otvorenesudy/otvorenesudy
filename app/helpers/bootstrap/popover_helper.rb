module Bootstrap
  module PopoverHelper
    def popover_tag(name, content, options = {})
      data = options.extract!(*%i(delay html placement trigger)).select { |_, v| v }
      options.deep_merge! data: data.merge(toggle: 'popover', content: content)
      link_to name, '#', options
    end
  end
end
