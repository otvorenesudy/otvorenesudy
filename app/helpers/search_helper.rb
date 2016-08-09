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

  # TODO rm!
  def search_list_tag(results, options = {}, &block)
    per_page = results.respond_to?(:per_page) ? results.per_page : options.delete(:per_page)
    offset   = options.delete(:offset)

    classes = ['search-results']
    classes << :'search-results-far' if per_page && (offset + per_page) > 1000

    content_tag :ol, class: classes, start: offset + 1 do
      results.each(&block)
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
