module TagHelper
  def time_tag(date_or_time, *args, &block)
    options = args.extract_options!
    content = localize date_or_time, options
    content = block.call content if block_given?
    super date_or_time, content, options
  end
end
