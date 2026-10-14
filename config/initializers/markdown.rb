# frozen_string_literal: true

# Static pages (app/views/static_pages/*.html.md) are ERB, then Markdown. Their links come from link_to and mail_to, so
# no autolinking, which would link the address inside a mail_to's link again.
module MarkdownTemplateHandler
  OPTIONS = { fenced_code_blocks: true, space_after_headers: true }.freeze

  def self.call(template, source)
    erb = ActionView::Template.registered_template_handler(:erb).call(template, source)

    "Redcarpet::Markdown.new(Redcarpet::Render::HTML, #{OPTIONS.inspect}).render(begin;#{erb};end.to_s).html_safe"
  end
end

ActionView::Template.register_template_handler :md, MarkdownTemplateHandler
