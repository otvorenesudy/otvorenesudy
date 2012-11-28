# encoding: utf-8

module ApplicationHelper
  def title(title = nil)
    base = "Otvorené súdy"

    if title.blank?
      base
    else
      "#{html_escape title} &middot; #{base}".html_safe
    end
  end
end
