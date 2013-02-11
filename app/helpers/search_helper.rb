module SearchHelper
  def category_title(title)
    content_tag :h4, title, class: 'title'     
  end

  def category_input(options)
    content_tag :input, nil, options.merge(name: :input, type: :text)
  end

  def category_list(options)
    content_tag :ul, nil, options.merge(id: "#{options[:id]}-list", class: :unstyled)
  end
end
