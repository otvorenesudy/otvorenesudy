# frozen_string_literal: true

module TextHelper
  # Joins the parts and truncates them to `limit` characters (plus the separators), on a word boundary. The rest shows
  # in a tooltip on the omission when `tooltip: true`.
  def join_and_truncate(text, options = {})
    separator = HTMLEntities.new.decode(options.fetch(:separator, ', '))
    parts = Array.wrap(text).map { |part| part.squeeze(' ').strip }
    limit = options.fetch(:limit, 30) + ((parts.size - 1) * separator.size)
    packed = parts.join(separator)

    return packed if packed.length <= limit

    shown = packed.truncate(limit, separator: ' ', omission: '').sub(/\s*#{Regexp.escape(separator.strip)}\s*\z/, '')
    omission = options.key?(:omission) ? options[:omission] : '&hellip;'

    safe_join([shown, truncation_marker(packed, shown, separator, omission, options)].compact)
  end

  # Highlighted fragments (<em> kept), joined with an ellipsis and wrapped in ellipses.
  def strip_and_highlight(text, options = {})
    ellipsis = tag.span('…', class: 'text-muted')
    separator = options.fetch(:separator) { safe_join([' ', ellipsis, ' ']) }
    omission = options.fetch(:omission, ellipsis)
    left, right = omission.is_a?(Hash) ? omission.values_at(:left, :right).map { |o| o || ellipsis } : [omission] * 2

    fragments = Array.wrap(text).map do |part|
      sanitize(part.gsub(/\A[^[:alnum:]<]+|[^[:alnum:]>]+\z/, ''), tags: %w[em])
    end

    safe_join([left && safe_join([left, ' ']), locale_specific_spaces(safe_join(fragments, separator)),
               right && safe_join([' ', right])].compact)
  end

  private

  # The omission after truncated text, with the rest of the text in a tooltip when asked.
  def truncation_marker(packed, shown, separator, omission, options)
    omission = sanitize(omission) if omission

    return omission unless options[:tooltip]

    rest = packed[(shown.rindex(separator) || 0)..].sub(/\A\s*#{Regexp.escape(separator.strip)}\s*/, '')

    tooltip_tag(omission || shown, rest, placement: options.fetch(:placement, 'right'))
  end
end
