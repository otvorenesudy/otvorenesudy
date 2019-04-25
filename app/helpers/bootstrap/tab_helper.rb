module Bootstrap
  module TabHelper
    def tab_link_tag(title, tab, options = {})
      path = options.delete(:path)
      classes = Array.wrap(options[:class]) << 'nav-link'
      tab_options = path ? options : options.deep_merge(data: { toggle: 'tab', target: "#tab-pane-#{tab}" }, role: 'tab')
      content_tag :li, class: 'nav-item' do
        link_to title, path.present? ? path : '#', tab_options.deep_merge(class: classes)
      end
    end

    def tab_content_tag(tab, options = {}, &block)
      classes = Array.wrap(options[:class]) << 'tab-pane'
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
