module TagHelper
  def help_tag(key, options = {})
    options = options.merge class: 'text-undecorated', trigger: 'hover'
    t("#{key}.title", default: '').tap { |t| options[:title] = t if t.present? }
    popover_tag icon_tag('help-outline'), t("#{key}.content"), options
  end

  def time_tag(date_or_time, *args, &block)
    options = args.extract_options!
    content = localize date_or_time, options
    content = block.call content if block_given?
    super date_or_time, content, options
  end
end
