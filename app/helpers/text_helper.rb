module TextHelper
  def join_and_truncate(text, options = {})
    @entities ||= HTMLEntities.new
    
    limit     = options.delete(:limit)     || 48
    separator = options.delete(:separator) || ', '
    omission  = options.delete(:omission)  || '&hellip;'
    tooltip   = options.delete(:tooltip)
    
    parts  = Array.wrap(text)
    limit += (parts.count - 1) * @entities.decode(separator).size
    
    packed = parts.map { |part| part.squeeze(' ').strip }.join separator
    result = truncate packed, length: limit, separator: ' ', omission: ''
    
    result.gsub!(/\s*#{separator.strip}\s*$/, '')
    
    if packed.length > limit
      if tooltip
        index   = result.rindex(separator) || 0 # TODO improve index matching
        title   = packed[index..-1].gsub(/^\s*#{separator.strip}\s*/, '')
        title   = html_escape @entities.decode(title)
        result += tooltip_tag omission.html_safe, title, { placement: :right }.merge(options)
      else
        result += omission
      end
    end
    
    result.html_safe
  end
  
  def strip_and_highlight(value, options = {})
    left = right = options[:omission] == false ? '' : options[:omission] || '&hellip;'
    
    left  = options[:left]  == false ? '' : options[:left]  || left
    right = options[:right] == false ? '' : options[:right] || right

    value = value.gsub(/\A([^[[:alnum:]]\<])+/, '') if left
    value = value.gsub(/([^[[:alnum:]]\>])+\z/, '') if right
    
    "#{left}#{sanitize value, tags: %w(em) }#{right}".html_safe 
  end
end
