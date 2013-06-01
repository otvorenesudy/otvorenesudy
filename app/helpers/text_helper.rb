module TextHelper
  def join_and_truncate(text, options = {})
    @entities ||= HTMLEntities.new
    
    limit     = options.delete(:limit)     || 55
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
end
