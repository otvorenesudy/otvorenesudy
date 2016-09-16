module Bootstrap
  module TooltipHelper
    def tooltip_tag(name, title, options = {})
      data = options.extract!(*%i(delay placement trigger)).select { |_, v| v }
      options.deep_merge! data: data.merge(toggle: 'tooltip'), title: title
      link_to name, '#', options
    end
  end
end
