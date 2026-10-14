# frozen_string_literal: true

module TagHelper
  # A question mark that explains a term on hover: `key.content`, and `key.title` if there is one.
  def help_tag(key, options = {})
    options = options.merge(class: 'd-inline text-info', trigger: 'hover')
    title = s(t("#{key}.title", default: ''))
    options[:title] = title if title.present?

    popover_tag icon_tag('question', size: 12), s(t("#{key}.content")), options
  end

  def span_tag(*, &)
    content_tag(:span, *, &)
  end

  # A <time> of the date or time, localized in the format given (format: :long).
  def time_tag(date_or_time, options = {})
    super(date_or_time, localize(date_or_time, **options), options)
  end
end
