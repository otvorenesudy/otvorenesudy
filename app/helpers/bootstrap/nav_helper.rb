module Bootstrap
  module NavHelper
    def nav_link_to(title, path, options = {})
      classes = %w(nav-item nav-link) + Array.wrap(options[:class])
      classes << :active if request.fullpath.start_with? path
      link_to title, path, class: classes
    end
  end
end
