module SearchHelper
  def facet_input(options)
    content_tag :input, nil, options.merge(name: :input, type: :text)
  end

  def facet_list(options)
    content_tag :ul, nil, options.merge(id: options[:id], :'data-id' => "#{options[:'data-id']}-list", class: :unstyled)
  end
  
  def link_to_search(type, body, options)
    url = "#{url_for(controller: type, action: :search)}#"

    params = options[:params]

    params.each { |field, values| params[field] = [values] unless values.is_a? Array }

    url << params.map { |field, values| "#{field}:#{values.join(';').gsub(/\s/,'+')}" }.join('&')

    link_to body, url, options.except(:params)
  end

  def link_to_hearings_search(body, options)
    link_to_search(:hearings, body, options)
  end

  def link_to_decrees_search(body, options)
    link_to_search(:decrees, body, options)
  end
end
