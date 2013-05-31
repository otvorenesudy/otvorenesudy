module TextHelper
  def join_and_truncate(text, options = {})
    limit     = options.delete(:limit)     || 40
    separator = options.delete(:separator) || ', '
    omission  = options.delete(:omission)  || '&hellip;'
    tooltip   = options.delete(:tooltip)
    
    parts  = Array.wrap(text)
    limit += (parts.count - 1) * separator.size
    
    packed = parts.map { |part| part.squeeze(' ').strip }.join separator
    result = truncate packed, length: limit, separator: ' ', omission: ''
    
    result.gsub!(Regexp.new("\s*#{separator}+\s*\z"), '')
    
    if packed.length > limit
      if tooltip
        result += tooltip_tag omission.html_safe, parts.last, { placement: :right }.merge(options)
      else
        result += omission
      end
    end
    
    result.html_safe
  end
end
