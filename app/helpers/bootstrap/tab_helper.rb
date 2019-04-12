module Bootstrap
  module TabHelper
    def tab_link_tag(title, tab, options = {})
      classes = Array.wrap(options[:class]).unshift 'nav-link'
      content_tag :li, class: 'nav-item' do
        link_to title, '#', options.deep_merge(class: classes, data: { toggle: 'tab', target: "#tab-pane-#{tab}" }, role: 'tab')
      end
    end

    def tab_content_tag(tab, options = {}, &block)
      classes = Array.wrap(options[:class]).unshift 'tab-pane'
      content_tag :div, options.merge(id: "tab-pane-#{tab}", class: classes, role: 'tabpanel'), &block
    end

    def render_tab(options = {}, locals = {}, &block)
      case options
      when Hash
        tab = options[:tab] || options[:partial].split('/').last
        block = -> { render options[:partial], options.fetch(:locals, locals) } unless block_given?
        tab_content_tag(tab, class: options[:class], &block)
      else
        tab_content_tag(options.split('/').last) { render options, locals }
      end
    end
  end
end
