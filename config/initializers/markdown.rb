MarkdownRails.configure do |config|
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true, autolink: true)

  config.render do |markdown_source|
    markdown.render(markdown_source)
  end
end

# TODO rm?
#class ActionView::Template::Handlers::Markdown
#  class_attribute :default_format
#  self.default_format = Mime::HTML
#  def call(template)
#    @erb ||= ActionView::Template.registered_template_handler :erb
#    @md  ||= Redcarpet::Markdown.new Redcarpet::Render::HTML, autolink: true, fenced_code_blocks: true
#    @md.render(template.source).html_safe
#  end     
#end
# 
#ActionView::Template.register_template_handler :md, ActionView::Template::Handlers::Markdown.new
