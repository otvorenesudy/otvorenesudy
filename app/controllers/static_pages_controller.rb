class StaticPagesController < ApplicationController
  def about
  end
  
  def contact
  end
  
  def home
    # TODO rm
    @count = 412569
    #@count = Hearing.count + Decree.count
  end
end
