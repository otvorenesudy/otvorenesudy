class ActionView::Template::Handlers::Markdown
  def call(template)
    @erb     ||= ActionView::Template.registered_template_handler :erb
    @options ||= { autolink: true, fenced_code_blocks: true, space_after_headers: true }
    
    "Redcarpet::Markdown.new(Redcarpet::Render::HTML, #{@options.to_s}).render(begin;#{@erb.call template};end)"
  end     
end
 
ActionView::Template.register_template_handler :md, ActionView::Template::Handlers::Markdown.new
