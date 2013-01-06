# encoding: utf-8

module ApplicationHelper
  def title(title = nil)
    base = "Otvorené súdy"

    return base if title.blank?

    "#{html_escape title} &middot; #{base}".html_safe
  end
end
