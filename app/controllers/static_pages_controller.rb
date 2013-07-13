class StaticPagesController < ApplicationController
  def home
    @count = Hearing.count + Decree.count
  end

  def show
    @slug = params[:slug]
    
    name = @slug.gsub(/-/, '_')
    
    @title    = translate "static_pages.#{name}", default: 'missing'
    @template = "static_pages/content/#{name}"

    begin
      render
    rescue ActionView::Template::Error => e
      if e.original_exception.is_a? ActionView::MissingTemplate
        raise ActionController::RoutingError.new nil
      end

      raise e 
    end
  end
end
