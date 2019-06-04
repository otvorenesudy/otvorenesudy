module SearchHelper
  def search_form_params(params)
    params.each_pair do |name, value|
      next if value.nil?

      if value.is_a? Array
        value.each { |v| yield "#{name}[]", v }
      else
        yield name, value
      end
    end
  end

  def search_sort_fields(current, fields)
    yield current.to_s.delete_prefix('_'), (fields - [current]).map { |field| [field.to_s.delete_prefix('_'), field] }
  end

  def search_list_tag(results, options = {}, &block)
    content_tag :ol, class: 'search-result-list', start: options[:offset] + 1 do
      results.each &block
    end
  end

  def link_to_search(type, body, options = {})
    url = url_for options[:params].merge(controller: type.to_s.downcase.pluralize, action: :index)

    link_to body, url, options.except(:params)
  end

  def link_to_courts_search(body, options = {})
    link_to_search(:courts, body, options)
  end

  def link_to_judges_search(body, options = {})
    link_to_search(:judges, body, options)
  end

  def link_to_hearings_search(body, options = {})
    link_to_search(:hearings, body, options)
  end

  def link_to_decrees_search(body, options = {})
    link_to_search(:decrees, body, options)
  end

  def link_to_proceedings_search(body, options = {})
    link_to_search(:proceedings, body, options)
  end
end
