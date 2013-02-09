# encoding: utf-8

module SearchHelper

  def category_title(title)
    content_tag :div, title, class: 'title'     
  end

  def category_input(options)
    content_tag :input, nil, 
      id:          options[:id], 
      name:        'input',
      type:        'text',
      placeholder: options[:placeholder]
  end

  def category_list(options)
    content_tag :ul, nil,
      id:    "#{options[:id]}-list",
      class: 'unstyled'
  end

  def hearing_title(hearing)
    headline  = hearing.form || hearing.subject || 'Pojednávanie'

    headline  = headline.value if headline.respond_to?(:value)
    
    link_to headline, hearing_path(hearing.id)
  end
end
