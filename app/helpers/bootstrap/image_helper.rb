# frozen_string_literal: true

module Bootstrap
  # Icons and logos from the SVG sprites (app/assets/images/icons.svg and brands.svg, built by bin/compile-icons).
  module ImageHelper
    SIZES = { base: 16, sm: 12, lg: 20 }.with_indifferent_access.freeze

    def icon_tag(name, options = {}, variants = {})
      sprite_tag 'icons', name, options, variants
    end

    def brand_tag(name, options = {}, variants = {})
      sprite_tag 'brands', name, options, variants
    end

    private

    def sprite_tag(sprite, name, options = {}, variants = {})
      variant = options.delete(:variant)
      options = options.merge(variants.fetch(variant, {}))
      size = options.delete(:size) || (:base unless options.key?(:width) || options.key?(:height))
      options = options.merge(width: SIZES.fetch(size, size), height: SIZES.fetch(size, size)) if size

      tag.svg(**options) do
        tag.use(href: "#{asset_path("#{sprite}.svg")}##{sprite}-#{name}#{".#{variant}" if variant}")
      end
    end
  end
end
