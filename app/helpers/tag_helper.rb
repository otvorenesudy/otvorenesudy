module TagHelper
  def square_tag(type, body, options = {})
    content_tag :span, body, options.merge(class: "label label-#{type.to_s}")
  end

  def round_tag(type, body, options = {})
    content_tag :span, body, options.merge(class: "badge badge-#{type.to_s}")
  end

  def icon_tag(type, options = {})
    icon  = content_tag :i, nil, class: "icon-#{type.to_s}"
    label = options.delete(:label)

    return icon if label.blank?

    label = label.to_s.html_safe
    join  = options.delete(:join)
    wrap  = options.delete(:wrap)
    space = content_tag :i, '&nbsp;'.html_safe, class: :'icon-space'
    body  = [icon, space, wrap.nil? || wrap ? content_tag(:span, label, options) : label]

    body.reverse! if join == :append
    body.join.html_safe
  end

  def icon_link_to(type, body, url = nil, options = {})
    options[:class] = Array.wrap(options[:class]) << :icon

    link_to icon_tag(type, label: body, join: options.delete(:join), wrap: options.delete(:wrap)), url, options
  end

  def icon_link_to_collapse(type, body, options = {})
    options.merge! data toggle: :collapse, collapse: options.delete(:action), target: options.delete(:target)

    icon_link_to type, body, '#', options
  end

  def icon_mail_to(type, body, url = nil, options = {})
    options[:class] = Array.wrap(options[:class]) << :icon

    url = body if url.blank?

    mail_to url, icon_tag(type, label: body, join: options.delete(:join)), options
  end

  def navbar_logo_tag(title)
    classes = [:capital]
    classes << :active if current_page? root_path

    content_tag :li, link_to(title, root_path, class: :brand), class: classes 
  end

  def navbar_li_tag(body, url, options = {})
    classes = Array.wrap options.delete(:class)
    classes << :active if request.fullpath.start_with? url

    content_tag :li, body, options.merge(class: classes.blank? ? nil : classes)
  end

  def navbar_link_tag(type, body, url, options = {})
    navbar_li_tag icon_link_to(type, body, url), url, options
  end

  def navbar_dropdown_tag(type, body, url, options = {}, &block)
    caret = options.delete(:caret)
    body  = icon_tag(caret, label: body, join: :append, wrap: true) if caret
    link  = icon_link_to(type, body, url, class: :'dropdown-toggle', :'data-toggle' => :dropdown, join: options.delete(:join), wrap: !caret)
    list  = content_tag :ul, capture(&block), class: :'dropdown-menu'
    body  = (link << list).html_safe

    navbar_li_tag body, url, options.merge(class: :dropdown)
  end

  def popover_tag(body, content, options = {})
    options.merge! data toggle: :popover, content: content, html: true, placement: options.delete(:placement) || :top, trigger: options.delete(:trigger) || :click

    link_to body, '#', options
  end

  def tooltip_tag(body, title, options = {})
    options.merge! data toggle: :tooltip, placement: options.delete(:placement) || :top, trigger: options.delete(:trigger) || :hover

    link_to body, '#', options.merge(title: title)
  end

  def sortable_table_tag(options = {}, &block)
    content_tag :table, options.merge(:'data-sortable' => true), &block
  end

  def sortable_th_tag(title = nil, options = {}, &block)
    options.merge! :'data-sorter' => options.delete(:sorter) || :text

    return content_tag :th, options, &block if block_given?

    content_tag :th, title, options
  end

  def link_to_with_count(body, url, count, options = {})
    count = content_tag :span, "&nbsp;(#{number_with_delimiter count})".html_safe, class: :muted

    link_to body.concat(count).html_safe, url, options
  end

  def tab_link_to_with_count(body, url, count, options = {})
    link_to_with_count body, url, count, options.merge(:'data-toggle' => :tab)
  end

  def close_link_to(url = nil, options = {})
    link_to icon_tag(:remove), url || '#', options.merge(class: :close)
  end

  def close_link_to_alert(options = {})
    close_link_to nil, options.merge(:'data-dismiss' => :alert)
  end

  def close_link_to_modal(options = {})
    close_link_to nil, options.merge(:'data-dismiss' => :modal)
  end

  def external_link_to(body, url, options = {})
    icon_link_to :'external-link', body, url, options.merge(target: :_blank, join: :append)
  end

  private

  def data(options = {})
    options.inject({}) { |o, (k, v)| o["data-#{k}"] = v; o }
  end 
end
