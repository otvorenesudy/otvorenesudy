# frozen_string_literal: true

module Bootstrap
  module CollapseHelper
    # A link that collapses or expands `target`. With two contents ([collapsed, expanded]), the link says what it will
    # do next ("show more" / "show less").
    def link_to_collapse(content, target, options = {})
      collapsed = options.delete(:collapsed) != false
      classes = Array.wrap(options[:class])
      classes << 'collapsed' if collapsed
      data = { bs_toggle: 'collapse' }

      if content.is_a?(Array)
        shown, alternate = collapsed ? content : content.reverse
        content = shown
        data.merge!(controller: 'collapse-label', action: 'collapse-label#swap',
                    collapse_label_alternate_value: alternate)
      end

      link_to content, target, options.deep_merge(class: classes.presence, data:)
    end
  end
end
