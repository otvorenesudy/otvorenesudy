# encoding: utf-8

module ApplicationHelper
  def title(title)
    base = "Otvorené súdy"

    if title.empty?
      base
    else
      "#{html_escape title} &middot; #{base}".html_safe
    end
  end
end
