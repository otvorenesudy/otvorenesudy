module Court::Map
  extend self
  
  def courts
    @courts ||=  Court.order(:name).all
  end
  
  def groups
    @groups ||= build_groups courts
  end
  
  def build_groups(courts)
    groups = {}
    
    courts.each do |court|
      groups[court.coordinates] ||= []
      groups[court.coordinates] << court
    end

    groups
  end
end
