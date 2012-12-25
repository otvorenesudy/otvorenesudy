module TagHelper
  def badge_tag(type, body, options = {})
    content_tag :span, body, options.merge(class: "badge badge-#{type.to_s}")
  end

  def external_link_to(body, url, options = {})
    options.merge! target: :_blank
    icon_link_to 'external-link', body, url, :append, options
  end

  def icon_tag(type, text = nil, join = :prepend, options = {})
    icon = content_tag :i, nil, class: "icon-#{type.to_s}"
    
    unless text.blank?
      space = content_tag :i, '&nbsp;'.html_safe, class: 'icon-space'
      body  = [icon, space, text.to_s]
      body.reverse! if join == :append
      icon = content_tag :span, body.join.html_safe, options
    end
    
    icon
  end
  
  def icon_link_to(type, body, url, join = :prepend, options = {})
    link_to icon_tag(type, body, join), url, options
  end
  
  def icon_mail_to(type, body, url = nil, join = :prepend, options = {})
    url = body if url.blank?
    mail_to url, icon_tag(type, body, join), options
  end

  def navbar_logo_tag(title)
    classes = [:capital]
    classes << :active if current_page? root_path
    content_tag :li, link_to(title, root_path, class: :brand), class: classes 
  end

  def navbar_li_tag(type, body, url, options = {})
    options.merge!(class: :active) if request.fullpath.start_with? url
    content_tag :li, icon_link_to(type, body, url), options
  end
  
  def popover_tag(body, content, title = nil, placement = :top, trigger = :click, options = {})
    options.merge! rel: :popover, title: title
    options.merge! data trigger: trigger, placement: placement, content: content, html: true
    link_to body, '#', options
  end
    
  def time_tag(time, format = :long_ordinal, options = {})
    options.merge! class: :timeago, title: time.getutc.iso8601
    content_tag :abbr, time.to_formatted_s(format), options
  end

  def tooltip_tag(body, title, placement = :top, trigger = :hover, options = {})
    options.merge! rel: :tooltip, title: title
    options.merge! data trigger: trigger, placement: placement
    link_to body, '#', options
  end
  
  private
  
  def data(options = {})
    options.inject({}) { |o, (k, v)| o["data-#{k}"] = v; o }
  end  
end
