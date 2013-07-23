# encoding: utf-8

class StaticPagesController < ApplicationController
  def show
    @slug = params[:slug]

    name = @slug.gsub(/-/, '_')

    @title    = translate "static_pages.#{name}", default: 'missing'
    @template = "static_pages/content/#{name}"

    begin
      render
    rescue ActionView::Template::Error => e
      if e.original_exception.is_a? ActionView::MissingTemplate # TODO: resolved ArgumentError when slug is not a valid identifier
        raise ActionController::RoutingError.new nil
      end

      raise e 
    end
  end
end
