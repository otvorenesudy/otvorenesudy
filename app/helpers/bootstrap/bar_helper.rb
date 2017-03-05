module Bootstrap
  module BarHelper
    def bar_link_to(title, path, options = {})
      classes = Array.wrap(options[:class]) << 'nav-item nav-link'
      classes << 'active' if request.fullpath.start_with? path
      link_to title, path, options.merge(class: classes)
    end
  end
end
