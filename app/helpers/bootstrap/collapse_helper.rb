module Bootstrap
  module CollapseHelper
    def link_to_collapse(content, target, options = {})
      classes = Array.wrap(options[:class])
      collapsed = !(options.delete(:collapsed) === false)
      data = options.extract!(:parent).select { |_, v| v }
      classes << 'collapsed' if collapsed

      if content.is_a? Array
        content.reverse! if collapsed
        options.deep_merge! data: { content: content.first }
        content = content.last
      end

      options.deep_merge! class: classes, data: data.merge(toggle: 'collapse')
      link_to content, target, options
    end
  end
end
