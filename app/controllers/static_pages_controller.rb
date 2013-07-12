class StaticPagesController < ApplicationController
  def home
    @count = Hearing.count + Decree.count
  end

  def show
    @slug  = params[:slug]
    @title = translate "static_pages.#{@slug}", default: 'missing'
    
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
