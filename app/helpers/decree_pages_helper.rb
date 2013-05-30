module DecreePagesHelper
  def link_to_decree_page(decree, query, page, title, options = {})
    link = "#{decree_path_with_params(decree, q: query)}#document/1/page/#{page}"

    link_to title, link, options
  end
end
