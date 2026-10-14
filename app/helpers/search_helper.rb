# frozen_string_literal: true

module SearchHelper
  # Each param as hidden form fields: name[] for each value of a list.
  def search_form_params(params)
    params.each_pair do |name, value|
      next if value.nil?

      if value.is_a?(Array)
        value.each { |item| yield "#{name}[]", item }
      else
        yield name, value
      end
    end
  end

  def search_list_tag(results, options = {}, &)
    tag.ol(class: 'search-result-list', start: options[:offset] + 1) do
      results.each(&)
    end
  end

  def link_to_search(type, body, options = {})
    url = url_for(options[:params].merge(controller: type.to_s.downcase.pluralize, action: :index))

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

  # The highlighted words of a search result, to highlight them again in the decree's document.
  def extract_highlight_tokens(highlights)
    Array.wrap(highlights).flat_map { |text| text.scan(%r{<em>(.*?)</em>}) }.flatten.map(&:downcase).uniq
  end
end
