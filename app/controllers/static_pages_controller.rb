class StaticPagesController < ApplicationController
  def home
    @count = Hearing.count + Decree.count
  end

  def show
    @slug = params[:slug]
    
    # TODO correctly render 404 instead of 500 on missing partial
  end
end
