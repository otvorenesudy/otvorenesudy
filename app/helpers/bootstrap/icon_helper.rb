module Bootstrap
  module IconHelper
    SIZES = { 'sm' => '.8rem', '' => '1rem', 'lg' => '1.5rem' }.freeze

    def icon_tag(name, options = {})
      size = SIZES.fetch(options[:size].to_s, options.delete(:size))
      use = content_tag(:use, nil, 'xlink:href' => "#icons-#{name}")
      content_tag :svg, use, options.merge(width: size, height: size)
    end
  end
end
