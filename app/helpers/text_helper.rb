module TextHelper
  def join_and_truncate(text, options = {})
    @entities ||= HTMLEntities.new

    limit     = options.delete(:limit)     || 30
    separator = options.delete(:separator) || ', '
    omission  = options.delete(:omission)  || '&hellip;'
    tooltip   = options.delete(:tooltip)

    parts  = Array.wrap(text)
    limit += (parts.size - 1) * @entities.decode(separator).size

    packed = parts.map { |part| part.squeeze(' ').strip } * separator
    result = truncate packed, length: limit, separator: ' ', omission: ''

    result.gsub!(/\s*#{separator.strip}\s*$/, '')

    if packed.length > limit
      if tooltip
        index   = result.rindex(separator) || 0
        title   = packed[index..-1].gsub(/\A\s*#{separator.strip}\s*/, '')
        title   = html_escape @entities.decode(title)
        result += tooltip_tag omission.html_safe, title, options.reverse_merge(placement: 'right')
      else
        result += omission
      end
    end

    result.html_safe
  end

  def strip_and_highlight(text, options = {})
    separator = options.delete(:separator) || content_tag(:span, ' &hellip; '.html_safe, class: 'text-muted')
    omission  = options.delete(:omission)  || content_tag(:span, '&hellip;'.html_safe, class: 'text-muted')

    parts = Array.wrap(text)

    packed = parts.map { |part| sanitize part.gsub(/\A[^[:alnum:]<]+|[^[:alnum:]>]+\z/, ''), tags: %w(em) } * separator
    result = "#{omission}&nbsp;#{locale_specific_spaces packed}&nbsp;#{omission}"

    result.html_safe
  end
end
