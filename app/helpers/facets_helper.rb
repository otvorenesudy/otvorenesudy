module FacetsHelper
  def facet_suggest_input_tag(facet, options = {})
    options['data-id'] ||= facet.name
    options['data-suggest-path'] ||= suggest_path(facet.params)

    tag :input, options.merge(type: :text, name: facet.name, class: 'facet-suggest')
  end

  def link_to_collapse_facet_results(facet)
    target = "##{facet.id}-list-more"

    link_to(t('search.facets.show_more'), '#', class: 'facet-results-more collapsed', data: { toggle: :collapse, target: target, collapse: :unfold }) +
    link_to(t('search.facets.show_less'), '#', class: 'facet-results-less collapsed', data: { toggle: :collapse, target: target, collapse: :fold })
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

  def translate_range_facet_value(facet, result)
    range   = result.range
    options = Hash.new

    case
    when range.begin == -Float::INFINITY
      entry = :less
      options[:count] = range.end.to_i != 0 ? range.end.to_i + 1 : range.end.to_i
    when range.end == Float::INFINITY
      entry = :more
      options[:count] = range.begin.to_i
    else
      entry = range.begin.to_i == range.end.to_i ? :exact : :between
      options[:lower] = range.begin.to_i
      options[:upper] = range.end.to_i
    end

    count = (options[:count] || options[:upper]).to_i

    options.each { |k, v| options[k] = number_with_delimiter v }

    path = "#{facet.key}.#{entry}"
    path = "facets.types.range.#{entry}" if missing_translation? path

    result = translate path, options
    suffix = "#{facet.key}.suffix"

    if entry == :less && count <= 1
      translate suffix, count: 0
    else
      result << translate(suffix, count: count).gsub(/\A\s*\d+/, '') unless missing_translation? suffix
    end
  end

  def link_to_facet_value(facet, result, value, options = {})
    path   = "#{facet.key}.#{value}"
    value  = translate path unless missing_translation? path
    count  = number_with_delimiter result.count
    body   = truncate value, length: 34 - (1 + count.size), separator: ' ', omission: '&hellip;'
    params = !result.selected? ? result.add_params : result.remove_params

    options.merge! data: { toggle: 'tooltip', placement: 'right', delay: '{ "show": 1000 }' }, title: value if body != value
    body.gsub!(/\s*[–]\s*&hellip;\z/, '&hellip;')
    body << content_tag(:span, count, class: 'facet-tag')

    link_to body.html_safe, options[:path] ? options[:path].call(params) : search_path(params), options
  end
end
