class DecreesController < ApplicationController
  def index
    @decrees = Decree.all
  end
  
  def show
    @decree = Decree.find(params[:id])
  end
end
