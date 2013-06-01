module DecreePagesHelper
  def link_to_decree_page(decree, page, body, options = {})
    link_to body, "#{decree_path_with_params decree, q: options.delete(:query)}#document/1/page/#{page}", options
  end
end
