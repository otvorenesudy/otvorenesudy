# encoding: utf-8

module SubscriptionsHelper
  def subscription_title(model, options = {})
    type = model.underscore.to_sym

    icon = case model.underscore.to_sym
           when :decree  then :legal
           when :hearing then :comments
           end

    content_tag :h4, options do
      content_tag(:span, icon_tag(icon, label: t(type, count: :other).capitalize))
    end
  end
end
