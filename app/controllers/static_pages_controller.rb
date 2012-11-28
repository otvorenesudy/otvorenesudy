class StaticPagesController < ApplicationController
  def about
  end
  
  def contact
  end
  
  def home
    @count = Hearing.count + Decree.count
  end
end
