module TagHelper
  def help_tag(key, options = {})
    options = options.merge trigger: 'hover'
    title = s(t "#{key}.title", default: '')
    options[:title] = title if title.present?
    popover_tag icon_tag('help-outline'), s(t "#{key}.content"), options
  end

  def time_tag(date_or_time, *args, &block)
    options = args.extract_options!
    content = localize date_or_time, options
    content = block.call content if block_given?
    super date_or_time, content, options
  end
end
