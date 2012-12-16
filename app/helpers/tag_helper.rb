module TagHelper
  def badge_tag(type, body, options = {})
    content_tag :span, body, options.merge(class: "badge badge-#{type.to_s}")
  end

  def icon_tag(type, text = nil, options = {})
    icon = content_tag :i, text.blank? ? nil : '&nbsp;'.html_safe, options.merge(class: "icon-#{type.to_s}")
    
    unless text.blank?
      body = [icon, text.to_s]
      body.reverse! unless options[:append].blank?
      icon = content_tag :span, body.join.html_safe, options
    end
    
    icon
  end
  
  def icon_link_to(type, body, url, options = {})
    link_to icon_tag(type, body), url, options
  end
  
  def icon_mail_to(type, body, url = nil, options = {})
    url = body if url.blank?
    options.merge body: icon_tag(type, body)
    mail_to url, icon_tag(type, body), options
  end

  def navbar_li_tag(type, body, url, options = {})
    options.merge!(class: :active) if current_page? url
    content_tag :li, icon_link_to(type, body, url), options
  end
    
  def time_tag(time, format = :long_ordinal, options = {})
    options.merge! class: :timeago, title: time.getutc.iso8601
    content_tag :abbr, time.to_formatted_s(format), options
  end

  def tooltip_tag(body, tip, position = :top, options = {})
    link_to body, '#', options.merge(rel: :tooltip, class: position, title: tip) 
  end  
end
