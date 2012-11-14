module HtmlHelper
  def badge_tag(text, *tags)
    content_tag :span, text, :class => 'badge' + tags.map { |tag| ' badge-' + tag.to_s }.join
  end

  def icon_tag(*tags)
    content_tag :i, nil, :class => tags.map { |tag| 'icon-' + tag.to_s }.join(' ')
  end
  
  def time_tag(time, format = :long_ordinal, options = {})
    options[:class] ||= 'timeago'
    
    content_tag :abbr, time.to_formatted_s(format), options.merge(:title => time.getutc.iso8601)
  end

  def tooltip_tag(text, tooltip, options = {})
    link_to text, '#', options.merge({ :rel => :tooltip, :title => tooltip }) 
  end  
end
