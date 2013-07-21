class ActionView::Template::Handlers::Markdown
  def call(template)
    compiled = (@erb ||= ActionView::Template.registered_template_handler :erb).call(template)
    "Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, fenced_code_blocks: true).render(begin;#{compiled};end)"
  end     
end
 
ActionView::Template.register_template_handler :md, ActionView::Template::Handlers::Markdown.new
