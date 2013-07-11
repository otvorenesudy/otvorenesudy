class StaticPagesController < ApplicationController
  def home
    @count = Hearing.count + Decree.count
  end

  def show
    @slug  = params[:slug]
    @title = t("static_pages.#{@slug}", default: 'missing')
  end
end
