# TODO rm, needed??

module DecreePagesHelper
  def link_to_decree_page(decree, page, body, options = {})
    link_to body, "#{decree_path decree, q: options.delete(:q)}#document/1/page/#{page}", options
  end
end
