module Bootstrap
  module ImageHelper
    SIZES = { base: 16, sm: 12, lg: 20 }.with_indifferent_access.freeze

    def icon_tag(name, options = {}, variants = {})
      use_within_svg_tag 'icons', name, options, variants
    end

    def brand_tag(name, options = {}, variants = {})
      use_within_svg_tag 'brands', name, options, variants
    end

    private

    def use_within_svg_tag(source, identifier, options = {}, variants = {})
      options = options.merge(variants.fetch(variant = options.delete(:variant), {}))
      size = options.delete(:size) || (:base unless options.key?(:width) || options.key?(:height))
      use = content_tag :use, nil, { 'xlink:href' => "#{asset_path "#{source}.svg"}##{source}-#{identifier}#{".#{variant}" if variant}" }
      content_tag :svg, use, size ? options.merge(width: SIZES.fetch(size, size), height: SIZES.fetch(size, size)) : options
    end
  end
end
