# frozen_string_literal: true

module TextHelper
  OMISSION = '…'

  # Joins the parts and truncates them to `limit` characters (plus the separators), on a word boundary, ending with an
  # ellipsis. The rest shows in a tooltip on the ellipsis when `tooltip: true`.
  def join_and_truncate(text, options = {})
    separator = HTMLEntities.new.decode(options.fetch(:separator, ', '))
    parts = Array.wrap(text).map { |part| part.squeeze(' ').strip }
    limit = options.fetch(:limit, 30) + ((parts.size - 1) * separator.size)
    packed = parts.join(separator)

    return packed if packed.length <= limit

    shown = packed.truncate(limit, separator: ' ', omission: '').sub(/\s*#{Regexp.escape(separator.strip)}\s*\z/, '')

    safe_join([shown, truncation_marker(packed, shown, separator, options)])
  end

  # Highlighted fragments (<em> kept), joined with an ellipsis and wrapped in ellipses.
  def strip_and_highlight(text)
    ellipsis = tag.span(OMISSION, class: 'text-muted')

    fragments = Array.wrap(text).map do |part|
      sanitize(part.gsub(/\A[^[:alnum:]<]+|[^[:alnum:]>]+\z/, ''), tags: %w[em])
    end

    safe_join([ellipsis, ' ', locale_specific_spaces(safe_join(fragments, safe_join([' ', ellipsis, ' ']))), ' ',
               ellipsis])
  end

  private

  # The ellipsis after truncated text, with the rest of the text in a tooltip when asked.
  def truncation_marker(packed, shown, separator, options)
    return OMISSION unless options[:tooltip]

    rest = packed[(shown.rindex(separator) || 0)..].sub(/\A\s*#{Regexp.escape(separator.strip)}\s*/, '')

    tooltip_tag(OMISSION, rest, placement: options.fetch(:placement, 'right'))
  end
end
