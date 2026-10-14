# frozen_string_literal: true

module TextHelper
  OMISSION = '…'

  # Joins the parts and truncates them to `limit` characters (plus the separators), on a word boundary, ending with an
  # ellipsis. The rest shows in a tooltip on the ellipsis when `tooltip: true`. A separator given as an entity
  # (' &ndash; ') takes the room of the entity, as the limits were set with it.
  def join_and_truncate(text, options = {})
    written = options.fetch(:separator, ', ')
    separator = HTMLEntities.new.decode(written)
    parts = Array.wrap(text).map { |part| part.squeeze(' ').strip }
    limit = options.fetch(:limit, 30) + ((parts.size - 1) * separator.size)
    packed = parts.join(separator)
    measured = parts.join(written)

    return packed if measured.length <= limit

    shown = measured.truncate(limit, separator: ' ', omission: '')
                    .sub(/\s*#{Regexp.escape(written.strip)}\s*\z/, '').gsub(written, separator)

    safe_join([shown, truncation_marker(packed, shown, separator, options)])
  end

  # The text with its first letter upper case, keeping the markup of HTML that starts with text; String#upcase_first
  # would return it as text, to be escaped.
  def upcase_first_html(text)
    return text.upcase_first if text.empty? || !text.html_safe?

    safe_join([text[0].upcase, text[1..]])
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
