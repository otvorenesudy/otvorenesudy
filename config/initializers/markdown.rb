# frozen_string_literal: true

# Static pages (app/views/static_pages/*.html.md) are ERB, then Markdown.
module MarkdownTemplateHandler
  OPTIONS = { autolink: true, fenced_code_blocks: true, space_after_headers: true }.freeze

  def self.call(template, source)
    erb = ActionView::Template.registered_template_handler(:erb).call(template, source)

    "Redcarpet::Markdown.new(Redcarpet::Render::HTML, #{OPTIONS.inspect}).render(begin;#{erb};end.to_s).html_safe"
  end
end

ActionView::Template.register_template_handler :md, MarkdownTemplateHandler
