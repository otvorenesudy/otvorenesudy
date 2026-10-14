# frozen_string_literal: true

module FacetsHelper
  # Typing in it narrows the facet's values (the facet-suggest controller).
  def facet_suggest_input_tag(facet, options = {})
    data = { facet_suggest_target: 'input', action: 'input->facet-suggest#search' }

    search_field_tag facet.name, nil, options.merge(id: nil, class: 'facet-suggest', autocomplete: 'off', data:,
                                                    'aria-label': options[:placeholder])
  end

  def link_to_facet_results_continuation(facet)
    link_to_collapse [t('search.facets.show_more'), t('search.facets.show_less')], "##{facet.id}-list-continuation",
                     class: 'facet-results-continuation'
  end

  def link_to_terms_facet(facet, result, options = {})
    link_to_facet_value facet, result, result.value, options
  end

  def link_to_date_facet(facet, result, options = {})
    key = "#{facet.key}.format.#{facet.interval}"
    key = "facets.types.date.format.#{facet.interval}" if missing_translation?(key)

    link_to_facet_value facet, result, l(result.value.begin, format: t(key)), options
  end

  def link_to_range_facet(facet, result, options = {})
    link_to_facet_value facet, result, translate_range_facet_value(facet, result), options
  end

  private

  # "5 až 9 sudcov", "menej ako 5 sudcov", "viac ako 100 sudcov"
  def translate_range_facet_value(facet, result)
    entry, values = range_entry(result.range)
    count = (values[:count] || values[:upper]).to_i
    values = values.transform_values { |value| number_with_delimiter(value) }

    path = "#{facet.key}.#{entry}"
    path = "facets.types.range.#{entry}" if missing_translation?(path)
    suffix = "#{facet.key}.suffix"

    return t(suffix, count: 0) if entry == :less && count <= 1
    return t(path, **values) if missing_translation?(suffix)

    "#{t(path, **values)}#{t(suffix, count:).sub(/\A\s*\d+/, '')}"
  end

  def range_entry(range)
    if range.begin == -Float::INFINITY
      [:less, { count: range.end.to_i.zero? ? 0 : range.end.to_i + 1 }]
    elsif range.end == Float::INFINITY
      [:more, { count: range.begin.to_i }]
    elsif range.begin.to_i == range.end.to_i
      [:exact, { lower: range.begin.to_i, upper: range.end.to_i }]
    else
      [:between, { lower: range.begin.to_i, upper: range.end.to_i }]
    end
  end

  # The value, translated if it has a translation (missing, activity...), with its count, truncated to fit the facet's
  # width; the whole value then shows in a tooltip.
  def link_to_facet_value(facet, result, value, options = {})
    key = "#{facet.key}.#{value}"
    value = missing_translation?(key) ? value.to_s.upcase_first : t(key)
    count = number_with_delimiter(result.count) unless options.delete(:count) == false
    label = value.truncate(31 - (count ? count.size + 1 : 0), separator: ' ', omission: '…').sub(/\s*–\s*…\z/, '…')
    path = options.delete(:path) || method(:search_path)
    params = result.selected? ? result.remove_params : result.add_params

    if label != value
      options = options.deep_merge(data: { controller: 'tooltip', bs_toggle: 'tooltip', bs_placement: 'right',
                                           bs_delay: '{ "show": 500 }', bs_title: value })
    end

    link_to safe_join([label, (tag.span(count, class: 'facet-tag') if count)].compact), path.call(params), options
  end
end
