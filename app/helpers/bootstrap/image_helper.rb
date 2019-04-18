module Bootstrap
  module ImageHelper
    SIZES = { base: '1rem', sm: '.8rem', lg: '1.5rem' }.with_indifferent_access.freeze

    def icon_tag(name, options = {})
      use = content_tag(:use, nil, 'xlink:href' => "#{asset_path 'icons.svg'}#icons-#{name}")
      content_tag :svg, use, fix_dimensions(options)
    end

    def brand_tag(name, options = {})
      use = content_tag(:use, nil, 'xlink:href' => "#{asset_path 'brands.svg'}#brands-#{name}")
      content_tag :svg, use, fix_dimensions(options)
    end

    private

    def fix_dimensions(options)
      size = options.delete(:size) || (:base unless options.key?(:width) || options.key?(:height))
      size ? options.merge(width: SIZES.fetch(size, size), height: SIZES.fetch(size, size)) : options
    end
  end
end
