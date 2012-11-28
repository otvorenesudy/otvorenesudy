module TagHelper
  def badge_tag(type, body, options = {})
    content_tag :span, body, options.merge(class: "badge badge-#{type.to_s}")
  end

  def icon_tag(type, body = nil, options = {})
    icon = content_tag :i, nil, options.merge(class: "icon-#{type.to_s}")
    
    unless body.blank?
      body = options[:append].blank? ? (icon + body.to_s) : (body.to_s + icon)
      icon = content_tag :span, body.html_safe, options      
    end
    
    icon
  end
  
  def time_tag(time, format = :long_ordinal, options = {})
    options[:class] ||= 'timeago'
    
    content_tag :abbr, time.to_formatted_s(format), options.merge(title: time.getutc.iso8601)
  end

  def tooltip_tag(body, tip, options = {})
     link_to_with_tooltip body, '#', tip, options
  end
  
  # TODO rm?
  def link_to_with_tooltip(body, url, tip = body, options = {})
    link_to body, url, options.merge({ rel: :tooltip, title: tip })
  end
  
  def link_to_with_icon( icon)
  end
end
