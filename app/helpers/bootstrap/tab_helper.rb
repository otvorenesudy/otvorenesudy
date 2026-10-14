# frozen_string_literal: true

module Bootstrap
  # Tabs whose links sit in a list with data-controller="tabs" (the URL's hash opens a tab).
  module TabHelper
    TAB_ACTIONS = 'shown.bs.tab->tabs#shown hidden.bs.tab->tabs#hidden'

    def tab_link_tag(title, tab, options = {})
      classes = Array.wrap(options[:class]).unshift('nav-link')
      data = { bs_toggle: 'tab', action: TAB_ACTIONS }

      tag.li(class: 'nav-item', role: 'presentation') do
        link_to title, "##{tab}", options.deep_merge(class: classes, data:, role: 'tab')
      end
    end

    def tab_content_tag(tab, options = {}, &)
      classes = Array.wrap(options[:class]).unshift('tab-pane')

      tag.div(**options, id: tab, class: classes, role: 'tabpanel', &)
    end

    def render_tab(options = {}, locals = {}, &block)
      return tab_content_tag(options.split('/').last) { render(options, locals) } unless options.is_a?(Hash)

      tab = options[:tab] || options[:partial].split('/').last
      block ||= -> { render(options[:partial], options.fetch(:locals, locals)) }

      tab_content_tag(tab, class: options[:class], &block)
    end
  end
end
