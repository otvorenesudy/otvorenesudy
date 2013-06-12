# encoding: utf-8

module FacetHelper
  def facet_input(facet, params, options)
    options.merge! :'data-id' => facet.name
    options.merge! :'data-suggest-path' => suggest_path(params)

    tag :input, options.merge(name: :input, type: :text)
  end

  def fulltext_facet_input(facet, options)
    options.merge! :'data-id' => facet.name

    tag :input, options.merge(name: :input, type: :text)
  end

  def form_facet_params(facet, &block)
    facet.params.except(facet.name).each_pair do |name, value|
      if value.respond_to? :each
        value.each { |v| yield "#{name}[]", v }
      else
        yield name, value
      end
    end
  end

  def multi_facet_prepend_input(facet, options)
    options.merge! :'data-id' => facet.name

    content_tag :div, class: 'input-prepend' do
      content_tag(:span, options[:prepend], class: 'add-on') +
      facet_input(facet, options.merge(class: 'input-mini'))
    end
  end

  def multi_facet_input(facet, options)
    facet_input facet, options.merge(class: 'input-mini')
  end

  def facet_list(options)
    content_tag :ul, nil, options.merge(id: options[:id], :'data-id' => options[:'data-id'], class: :unstyled)
  end

  def link_to_facet(facet, result, options = {})
    case facet.type
    when :terms   then link_to_terms_facet facet, result, options
    when :range   then link_to_range_facet facet, result, options
    when :date    then link_to_date_facet facet, result, options
    else               link_to result.value, search_path(result.params)
    end
  end

  def link_to_facet_value(facet, result, value, options)
    path  = "#{facet.key}.#{value}"

    value = t path unless missing_translation? path

    link_to format_facet_value(value), search_path(result.params), options
  end

  def link_to_terms_facet(facet, result, options)
    link_to_facet_value(facet, result, result.value, options)
  end

  def link_to_date_facet(facet, result, options)
    value = result.value

    key = "#{facet.key}.format.#{facet.interval}"

    key = "facets.types.date.format.#{facet.interval}" if missing_translation? key

    value = l value.begin, format: t(key)

    link_to_facet_value facet, result, value, options
  end

  def link_to_range_facet(facet, result, options)
    value = translate_range_facet(facet, result)

    link_to_facet_value facet, result, value, options
  end

  def link_to_add_facet(facet, result, options = {})
    icon_link_to :plus, nil, search_path(result.add_params), class: :add
  end

  def link_to_remove_facet(facet, result, options = {})
    icon_link_to :remove, nil, search_path(result.remove_params), class: :remove
  end

  def collapse_facet_link(facet)
    target = "##{facet.id}-fold"

    collapse_link(:fold, :'collapse-alt', 'Zobrazit menej', :'data-target' => target, class: 'hidden muted') +
    collapse_link(:unfold, :'expand-alt', 'Zobraziť viac', :'data-target' => target, class: :muted)
  end

  private

  def format_facet_value(value)
    value.gsub!(/\d+/) { |m| number_with_delimiter(m.to_i) }

    join_and_truncate value, limit: 30
  end

  def missing_translation?(key)
    t(key, default: "__missing__") == "__missing__"
  end

  def translate_range_facet(facet, result)
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
      entry           = :between
      options[:lower] = range.begin.to_i
      options[:upper] = range.end.to_i
    end

    count  = options[:count] || options[:upper]

    path   = "#{facet.key}.#{entry}"
    suffix = "#{facet.key}.suffix"

    if missing_translation?(path)
      path = "facets.types.range.#{entry}"
    end

    result = t path, options

    unless missing_translation?(suffix)
      result.sub!(/\d+\z/, t(suffix, count: count))
    end

    result
  end
end
