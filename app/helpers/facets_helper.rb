# encoding: utf-8

module FacetsHelper
  def facet_form_params(facet, &block)
    form_params(facet.params.except(facet.name), &block)
  end

  def facet_suggest_input(facet, options = {})
    options.merge! :'data-id' => facet.name
    options.merge! :'data-suggest-path' => suggest_path(facet.params)

    tag :input, options.merge(type: :text, name: facet.name)
  end

  def facet_multi_input(facet, options = {})
    options.merge! :'data-id' => facet.name

    prefix = options.delete(:prefix)
    input  = facet_suggest_input facet, options.merge(class: :multi)

    return input unless prefix

    content_tag :div, class: 'input-prepend' do
      content_tag(:span, prefix, class: 'add-on') + input
    end
  end

  def link_to_add_facet(facet, result, options = {})
    icon_link_to :plus, nil, search_path(result.add_params), class: :add
  end

  def link_to_remove_facet(facet, result, options = {})
    icon_link_to :remove, nil, search_path(result.remove_params), class: :remove
  end

  def link_to_collapse_facet_results(facet)
    target = "##{facet.id}-fold"

    icon_link_to_collapse(:collapse, 'Zobraziť viac', action: :unfold, target: target, join: :append, class: :muted) +
    icon_link_to_collapse(:'collapse-top', 'Zobrazit menej', action: :fold, target: target, join: :append, class: :muted)
  end

  def link_to_terms_facet(facet, result, options = {})
    link_to_facet_value facet, result, result.value, options
  end

  def link_to_date_facet(facet, result, options = {})
    value = result.value
    key   = "#{facet.key}.format.#{facet.interval}"
    key   = "facets.types.date.format.#{facet.interval}" if missing_translation? key
    value = localize value.begin, format: translate(key)

    link_to_facet_value facet, result, value, options
  end

  def link_to_range_facet(facet, result, options = {})
    link_to_facet_value facet, result, translate_range_facet_value(facet, result), options
  end

  private

  def format_facet_number(number)
    number_with_delimiter(number)
  end

  def format_facet_value(result, value)
    truncate(value, length: 37 - (3 + result.count.to_s.size), separator: ' ', omission: '&hellip;').html_safe
  end

  def translate_range_facet_value(facet, result)
    range   = result.range
    options = Hash.new

    case
    when range.begin == -Float::INFINITY
      entry           = :less
      options[:count] = range.end.to_i
    when range.end == Float::INFINITY
      entry           = :more
      options[:count] = range.begin.to_i
    else
      options[:lower] = range.begin.to_i
      options[:upper] = range.end.to_i

      entry = range.begin.to_i == range.end.to_i ? :exact : :between
    end

    options.each { |k, v| options[k] = format_facet_number(v) }

    path = "#{facet.key}.#{entry}"
    path = "facets.types.range.#{entry}" if missing_translation?(path)

    result = translate path, options
    suffix = "#{facet.key}.suffix"
    count  = (options[:count] || options[:upper]).to_i

    if entry == :less && count <= 1
      translate(suffix, count: 0)
    else
      # TODO: fix count deletion from translation
      result << translate(suffix, count: count).gsub(/\d+/, '') unless missing_translation?(suffix)
      result
    end
  end

  def link_to_facet_value(facet, result, value, options = {})
    path  = "#{facet.key}.#{value}"
    value = translate path unless missing_translation? path
    body  = format_facet_value(result, value)

    options.merge! title: value if body != value

    options.merge!(:'data-searchd-filter' => "#{facet.id}", :'data-searchd-filter-value' => result.value) if result.selected

    link_to body, search_path(result.params), options
  end
end
