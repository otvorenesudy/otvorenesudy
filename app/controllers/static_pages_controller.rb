class StaticPagesController < ApplicationController
  def home
    @count = Hearing.count + Decree.count
  end

  def show
    @slug     = params[:slug]
    @template = @slug.gsub(/-/, '_')
    @title    = translate "static_pages.#{@template}", default: 'missing'
    
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
