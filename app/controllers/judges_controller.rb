class JudgesController < ApplicationController
  def index
    @judges = Judge.all
  end
  
  def show
    @judge = Judge.find(params[:id])
  end
end
