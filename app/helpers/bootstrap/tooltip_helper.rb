module Bootstrap
  module TooltipHelper
    def tooltip_tag(content, title, options = {})
      (options[:data] ||= {}).merge toggle: 'tooltip', placement: options.delete(:placement)
      content_tag :span, content, options.merge(title: title)
    end
  end
end
