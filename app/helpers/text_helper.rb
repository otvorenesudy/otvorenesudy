module TextHelper
  def join_and_truncate(text, options = {})
    limit     = options.fetch :limit, 30
    separator = options.fetch :separator, ', '
    omission  = options.fetch :omission, '&hellip;'
    tooltip   = options.fetch :tooltip, false

    entities = HTMLEntities.new

    parts  = Array.wrap(text)
    limit += (parts.size - 1) * entities.decode(separator).size

    packed = parts.map { |part| part.squeeze(' ').strip } * separator
    result = truncate packed, length: limit, separator: ' ', omission: ''

    result.gsub!(/\s*#{separator.strip}\s*$/, '')

    if packed.length > limit
      if tooltip
        index   = result.rindex(separator) || 0
        title   = packed[index..-1].gsub(/\A\s*#{separator.strip}\s*/, '')
        title   = html_escape entities.decode(title)
        tooltip = tooltip_tag (omission || result).html_safe, title, placement: options.fetch(:placement, 'right')

        omission ? result += tooltip : result = tooltip
      else
        result += omission if omission
      end
    end

    result.html_safe
  end

  def strip_and_highlight(text, options = {})
    wrapper = -> (s) { content_tag(:span, s.html_safe, class: 'text-muted') }

    separator = options.fetch(:separator) { " #{wrapper.call('&hellip;')} " }
    omission  = options.fetch(:omission) { wrapper.call('&hellip;') }

    if omission.is_a? Hash
      left, right = %i(left right).map { |k| omission.fetch(k) { wrapper.call '&hellip;' }}
    else
      left, right = omission, omission
    end

    parts = Array.wrap(text)

    packed = parts.map { |part| sanitize part.gsub(/\A[^[:alnum:]<]+|[^[:alnum:]>]+\z/, ''), tags: %w(em) } * separator
    result = "#{"#{left}&nbsp;" if left}#{locale_specific_spaces packed}#{"&nbsp;#{right}" if right}"

    result.html_safe
  end
end
