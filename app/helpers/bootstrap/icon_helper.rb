module Bootstrap
  module IconHelper
    def icon_tag(name, options = {})
      classes = Array.wrap(options[:class]) << "ion-#{'ios-' if name !~ /\A(android|social)/}#{name}"
      content_tag :span, nil, options.merge(class: classes)
    end
  end
end
