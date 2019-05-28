module FacetsHelper
  def facet_suggest_input_tag(facet, options = {})
    data = { id: facet.name, path: options.delete(:path) || suggest_path(facet.params) }

    tag :input, options.merge(type: 'text', name: facet.name, class: 'facet-suggest', data: data)
  end

  def link_to_facet_results_continuation(facet)
    content = [t('search.facets.show_more'), t('search.facets.show_less')]

    link_to_collapse content, "##{facet.id}-list-continuation", class: 'facet-results-continuation'
  end

  def link_to_terms_facet(facet, result, options = {})
    link_to_facet_value facet, result, result.value, options
  end

  def link_to_date_facet(facet, result, options = {})
    value = result.value
    key   = "#{facet.key}.format.#{facet.interval}"
    key   = "facets.types.date.format.#{facet.interval}" if missing_translation? key
    value = localize value.begin, format: t(key)

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

    result = t path, options
    suffix = "#{facet.key}.suffix"

    if entry == :less && count <= 1
      t suffix, count: 0
    else
      result << t(suffix, count: count).gsub(/\A\s*\d+/, '') unless missing_translation? suffix
    end
  end

  def link_to_facet_value(facet, result, value, options = {})
    key    = "#{facet.key}.#{value}"
    value  = missing_translation?(key) ? value.upcase_first : t(key)
    count  = options.delete(:count) === false ? nil : number_with_delimiter(result.count)
    body   = truncate value, length: 31 - (count ? 1 + count.size : 0), separator: ' ', omission: '&hellip;'
    path   = options.delete(:path) || method(:search_path)
    params = !result.selected? ? result.add_params : result.remove_params

    options.deep_merge! data: { toggle: 'tooltip', placement: 'right', delay: '{ "show": 500 }' }, title: value if body != value

    body.gsub!(/\s*[–]\s*&hellip;\z/, '&hellip;')
    body << content_tag(:span, count, class: 'facet-tag') if count.present?

    link_to body.html_safe, path.call(params), options
  end
end
